# Handoff

This repository started as a copy of a personal NixOS setup (bare metal, Hyper-V VM and WSL) and was reduced to a work setup that runs only under WSL. Removed in that step: the bare-metal and VM boot loaders and hardware configurations, os-prober, the NFS mounts, the Hyprland desktop (system and Home Manager, incl. the Quickshell bar, hyprlock login, swaync, fuzzel, GTK / Qt / viewer theming), the other desktops (KDE, GNOME, COSMIC, ReGreet, Nemo, the Home Manager KDE settings), audio, Bluetooth, printing, and the applications 3D printing (Blender, OpenSCAD, OrcaSlicer), Claude Code, Rider, gaming (Steam, Sunshine), office (LibreOffice) and Firefox, fastfetch, pywal and the wallpapers. The colour profile stays, for the terminal and its tools: the palette pywal last generated is kept as fixed colours in `home-manager/theme.nix`.

What was built, why it was built that way, what went wrong and how it was fixed, and what is still open. For how to use the configuration, see [README.md](README.md) and [home-manager/README.md](home-manager/README.md).

## Working environment

- **Development happens on Windows.** Nothing can be built there.
- **Builds are checked in the NixOS-WSL distro `NixOS`.** There, `/etc/nixos` can be a symlink to the repository under `/mnt/c/...`. Run scripts with `wsl -d NixOS -- bash -l /mnt/c/.../script.sh` from PowerShell:
  - Git Bash rewrites `/mnt/c/...` arguments into Windows paths.
  - Inline pipes get mangled by PowerShell quoting.
  - Write the script to a file first.
- **Check Home Manager changes** with:

  ```bash
  nix build --no-write-lock-file --no-link --print-out-paths .#homeConfigurations.max.activationPackage
  ```

  Then read the generated files under `<out>/home-files/`.
- **Always use `--no-write-lock-file` for test builds of `home-manager/`.** Without it, Nix creates `home-manager/flake.lock` in the repository and marks it with `git add --intent-to-add` (see [Problems and fixes](#problems-and-fixes)).
- **Git conventions:**
  - Changes are staged with `git add`; the maintainer commits.
  - Flakes only see tracked files, so new files must be staged before any build.
  - The maintainer edits `vars.nix` themselves and `home-manager/theme.nix` (e.g. `kitty.fontSize`). Keep their values.

## Architecture in short

| Part | Applied with | Contents |
|---|---|---|
| `flake.nix`, `configuration.nix`, `core/`, `system/` | `nrs` = `sudo nixos-rebuild switch --flake .` (host from the hostname) | NixOS-WSL, users, services |
| `applications/` (own flake) | Same rebuild | Every program, installed system-wide |
| `environment/` (own flake) | Same rebuild | System-wide environment variables (formerly `system/shell/env.nix`) |
| `home-manager/` (own flake, template) | `hms` = `home-manager switch --flake ~/.config/home-manager#<user>` | Per-user settings only, installs no programs (`package = null`) |

- Each part has its own `vars.nix`.

## Decisions

### System

| Decision | Why |
|---|---|
| **One flake output per host** (`hosts` in `flake.nix`, by default `wsl`), named after its hostname, which it also sets. `vars.nix` is a function of `hostName`. | `nixos-rebuild --flake .` picks the host by hostname and stops if there's none. |
| **No desktop, audio, Bluetooth or printing modules** | WSL has no screen or hardware of its own; GUI apps use WSLg. `theme-lib.nix` moved from `home-manager/desktop/` to `home-manager/`. |
| **`nh` for cleanup instead of `nix.gc`** (`--keep-since 14d --keep 5`), `nrs` unchanged | nh keeps a minimum number of generations and shows package diffs. `nrs` stays the documented way. |
| **msodbcsql17 overridden to 17.11.1.1** (`applications/databases/mssql-odbc`): new version, source from Microsoft's Debian bullseye repository, `postFixup` and `passthru` (`fancyName`, `driver`) recomputed for the new library name | nixpkgs' 17.7.1.1 only loads OpenSSL 1.1; OpenSSL 3 is supported from 17.10. `overrideAttrs` doesn't recompute attributes that nixpkgs built from its own version numbers, so `postFixup` and `passthru.driver` must be set again; otherwise `/etc/odbcinst.ini` points at a missing `libmsodbcsql-17.7.so.1.1`. nixpkgs' install step hardcodes major version 17. |
| **nix-index-database flake input** for `comma` / command-not-found | Building the nix-index database locally takes a long time; the input brings a prebuilt weekly one. `programs.command-not-found` is off: it needs a channel, which a flake system doesn't have. |

### Home Manager

| Decision | Why |
|---|---|
| **Bash init of zoxide, fzf, mcfly, broot, pay-respects and the eza aliases is guarded** with `command -v` | The HM template can be applied where a program isn't installed (WSL before the rebuild was active). Unguarded, every shell printed "command not found" and `ls` broke. |
| **Large kitty font** (`kitty.fontSize` = 16 in `theme.nix`) | WSLg doesn't scale for high DPI. |
| **Fixed colours instead of pywal**: the palette pywal16 generated from the last wallpaper (backend `modern_colorthief`, saturate 0.6) is stored in `theme.nix` (`colors`). kitty gets the same colours file pywal wrote, other terminals the same escape sequences when bash starts (`applications/terminal/terminal-colors.nix`) | Keeps the look without pywal, its backend libraries and the wallpapers. Error and warning stay Catppuccin red / yellow (`alerts`), as they were with pywal. |
| **The colour profile in `home-manager/theme.nix`**, imported by `vars.nix` as `theme` (palette, alerts, roles, highlights, prompt, kitty) | Values that should match share one base value, while each can still be overridden. `theme.nix` is `rec` for that; modules read `vars.theme.*`. The colour files of all programs come from the functions in `theme-lib.nix`. |

How each program gets the colours:

| Program | Channel |
|---|---|
| kitty | `include colors.conf` (`~/.config/kitty/colors.conf`) |
| Other terminals | Escape sequences printed by bash (`terminal-colors.nix`) |
| bat, fzf, btop | Follow the terminal palette: bat theme `ansi`, fzf `--color=16`, btop theme `~/.config/btop/themes/theme.theme` |
| powerline, tmux, superfile, ripgrep, micro, yazi, oxker, Neovim | Their colour file from `theme-lib.nix` |

## Problems and fixes

| Problem | Cause | Fix |
|---|---|---|
| `.git/index.lock` exists | Stale lock from another git process | Cleared by itself; don't delete it blindly |
| WSL: `zoxide`, `fzf`, `mcfly`, `broot`, `pay-respects`: command not found; `ls` broken | WSL still ran the old generation (built with `boot`); the eza alias pointed to a missing `eza` | Restart WSL (`wsl -t NixOS`, `wsl -d NixOS --user root exit`, `wsl -t NixOS`); bash init and aliases guarded with `command -v` |
| WSLg apps tiny; `.wslgconfig` had no effect | Section was `[system]` | `[system-distro-env]` with `WESTON_RDP_HI_DPI_SCALING`, `WESTON_RDP_FRACTIONAL_HI_DPI_SCALING`, `WESTON_RDP_DEBUG_DESKTOP_SCALING_FACTOR`, then `wsl --shutdown` |
| ODBC Driver 17 for SQL Server couldn't use the system's OpenSSL 3 | nixpkgs packages msodbcsql 17.7.1.1, which predates OpenSSL 3 support (added in 17.10) | Override to 17.11.1.1 (see [Decisions](#system)). Checked: `/etc/odbcinst.ini` points at `libmsodbcsql-17.11.so.1.1`, its RUNPATH has openssl-3.5, and `isql` with drivers 17 and 18 loads `libcrypto.so.3` and gets as far as the TCP connect |
| Arrow-up returned several commands at once | `HISTTIMEFORMAT` made bash write `#<timestamp>` lines to `~/.bash_history` and read everything up to the next one as one entry (bash 5); mcfly appends commands without timestamps, so whole runs merged | `HISTTIMEFORMAT` removed from `environment/`; bash then reads one command per line, also from the existing file. mcfly still shows times (its own database) |
| PyCharm terminal (WSL shell): cursor stuck on the right behind the git branch, every key started a new line | Powerline draws the bash prompt's right side (branch) with cursor save / restore (`ESC[s`, `ESC[u`), which JediTerm ignores | `home-manager/applications/terminal/powerline.nix`: the JetBrains terminal (`TERMINAL_EMULATOR=JetBrains-JediTerm`) gets `prompt.jetbrainsTheme` from `home-manager/vars.nix`, default `default_leftonly` (branch on the left, no cursor jumps); all other terminals get `prompt.theme` |
| `home-manager/flake.lock` appeared in the git index (empty, intent-to-add) | Test builds of the HM flake inside the repository without `--no-write-lock-file` | `git rm --cached home-manager/flake.lock` and delete it; test builds now use `--no-write-lock-file` |

## Open items

- In the palette, `color7` (role `dimmed`) equals the foreground, so dimmed text isn't dimmed. A darker `color7` in `theme.nix` would fix it.
- `home-manager` is installed only for the user from the system `vars.nix` (`core/users.nix`). Moving it to `environment.systemPackages` would make it available to every user on the first setup.
- `hmr` / `nfr` copy the template over `~/.config/home-manager`, including `vars.nix`, so local edits are lost.
- Offered but not done:
  - `wsl.startMenuLaunchers` (Linux apps in the Windows start menu)
  - `QT_SCALE_FACTOR`
