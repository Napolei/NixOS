# nix-os-configs

NixOS-WSL system configuration and a standalone Home Manager template, managed with Nix flakes.

## Overview

The configuration is split by who applies it:

- **System** (`flake.nix`, `configuration.nix`, `core/`, `system/`): NixOS-WSL, services, networking and user accounts. Applied with `sudo`.
- **Applications** (`applications/`): every program installed system-wide, as its own flake exporting NixOS modules. Imported by the system flake and applied with it.
- **Environment variables** (`environment/`): the system-wide environment variables, as its own flake exporting a NixOS module. Imported by the system flake and applied with it. Variables of a single program stay in that program's module.
- **User settings** (`home-manager/`): a standalone Home Manager template that each user copies to `~/.config/home-manager` and applies without `sudo`. It only holds per-user settings (dotfiles, colours, aliases); it doesn't install programs. See [home-manager/README.md](home-manager/README.md).

NixOS runs in WSL through [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) (flake input `nixos-wsl`). The configuration:

- enables NixOS-WSL with the user from `vars.nix` as the default user (`system/hardware/hardware-configuration-wsl.nix`)
- leaves the boot loader alone (`core/bootloader_changes_disabled.nix`), and skips NetworkManager and the firewall
- installs no desktop, login screen, X server, audio, Bluetooth or printing. GUI apps such as kitty open as Windows windows through WSLg.

## Setup

A fresh NixOS-WSL has **no git and no `home-manager` command**. The steps below get around that: git comes from a temporary `nix-shell`, flakes are enabled for the first build only, and `home-manager` is installed by that build. Afterwards all three are part of the system.

1. **Install NixOS-WSL.** Download `nixos.wsl` from the [NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases), then in Windows PowerShell:

   ```powershell
   wsl --install --from-file nixos.wsl
   wsl -d NixOS
   ```

   You're logged in as `nixos`.

2. **Get the repository.** Open a temporary shell with git, and move the generated configuration aside:

   ```bash
   nix-shell -p git
   sudo mv /etc/nixos /etc/nixos.orig
   sudo git clone <this repository> /etc/nixos
   ```

   **Repository already on the Windows side** (e.g. `C:\Development\git-projects\nix-os-configs`): link it instead of cloning, so Windows and WSL share one copy. git refuses repositories owned by another user, so mark it as safe:

   ```bash
   sudo ln -s /mnt/c/Development/git-projects/nix-os-configs /etc/nixos
   git config --global --add safe.directory /mnt/c/Development/git-projects/nix-os-configs
   sudo git config --global --add safe.directory /mnt/c/Development/git-projects/nix-os-configs
   ```

3. **Adjust `vars.nix`** before the first build:
   - `user.username`, `user.description`, `user.uid`
   - `user.hashedPassword`: generate one with `nix-shell -p whois --run "mkpasswd -m sha-512"`. Without your own hash, the account gets the password of the hash in the repository.
   - `system.timeZone`, `system.defaultLocale`, `system.keyboardLayout`

   New files must be added to git before building (`git add <file>`), see the note below.

4. **Build.** Use `boot` instead of `switch`, because the default user changes:

   ```bash
   cd /etc/nixos
   sudo NIX_CONFIG="experimental-features = nix-command flakes" \
     nixos-rebuild boot --flake .#wsl
   exit
   ```

   The build also sets the hostname to `wsl`, so later rebuilds find the configuration by themselves.

5. **Restart as the new user.** A `boot` build only takes effect after WSL restarts. In Windows PowerShell:

   ```powershell
   wsl -t NixOS
   wsl -d NixOS --user root exit
   wsl -t NixOS
   wsl -d NixOS
   ```

   You're now logged in as the user from `vars.nix`, and the hostname is `wsl`. `readlink /run/current-system` must point to the new generation; if programs such as `eza` are missing, WSL is still running the old one, so repeat the restart.

6. **User settings.** Follow [home-manager/README.md](home-manager/README.md#first-time-setup). You get the shell, the aliases, the colour profile and the program settings.

After that, rebuild with `nrs` in `/etc/nixos`.

> **Flakes only see files tracked by git.** After adding a new file, run `git add` on it before rebuilding, otherwise the rebuild fails with "path ... does not exist".

## Repository structure

```text
.
├── flake.nix                     # System flake: one configuration per host (wsl), inputs incl. NixOS-WSL
├── configuration.nix             # Root module
├── vars.nix                      # System-wide variables and flags (see below)
├── HANDOFF.md                    # Decisions, problems and fixes, open items
├── core/
│   ├── bootloader_changes_disabled.nix  # Boot loader untouched
│   ├── locale.nix                # Time zone, locale, keyboard layout
│   ├── nix.nix                   # Nix settings (flakes)
│   ├── security.nix              # sudo and security policies
│   └── users.nix                 # User account
├── system/
│   ├── fonts.nix, networking.nix
│   ├── hardware/
│   │   └── hardware-configuration-wsl.nix
│   └── shell/                    # System-wide aliases
├── environment/                  # System-wide environment variables (own flake)
├── applications/                 # System-wide programs, one folder per purpose, one per program in it (see below)
│   ├── containers/               # Docker, oxker
│   ├── databases/                # SQL Server ODBC drivers
│   ├── development/              # git, direnv
│   ├── editors/                  # micro, nano, neovim, PyCharm
│   ├── files/                    # File managers, listings, navigation, archives
│   ├── languages/                # Node.js with npm, Python with Poetry, pipx and uv
│   ├── network/                  # HTTP clients, downloads, DNS, ping, cloud storage
│   ├── search/                   # fd, fselect, fzf, ripgrep
│   ├── system/                   # Monitors, disk usage, system information, WSL utilities
│   ├── terminal/                 # kitty, tmux, prompt, shell helpers
│   └── text/                     # bat, choose, jq / yq
└── home-manager/                 # Per-user settings template, see home-manager/README.md
```

## System variables (`vars.nix`)

| Section | What it sets |
|---|---|
| `system` | `stateVersion`, `timeZone`, `defaultLocale`, `keyboardLayout` |
| `hostName` | Set by `flake.nix` (see below) |
| `user` | User name, description, password hash, UID |
| `jetbrains.usePro` | PyCharm Professional instead of Community |
| `python.venvPath` | Base folder of the virtual environments Poetry creates (default `$HOME/.virtualenvs`), set as `POETRY_VIRTUALENVS_PATH` |
| `nodejs.npmGlobalPath` | Folder of global npm packages (default `$HOME/.npm-global`), set as `NPM_CONFIG_PREFIX`, its `bin` on the `PATH` |
| `packageVersions` | Pinned versions: `python` (source build of that release) and `poetry` (Poetry with its matching poetry-core), each with a `version` and a source `hash`; `uv`, with a `version`, a source `hash` and a `cargoHash` for its Rust dependencies; `nodejs`, the Node.js major version (e.g. `"24"`) |

### Hosts

`flake.nix` has one configuration per distro, named after its hostname (`hosts`, by default only `wsl`). The build sets the hostname to the host's name, and `nixos-rebuild switch --flake .` (the `nrs` alias) builds the configuration named after the current hostname. If there is none, the rebuild stops.

- The first build in a distro names the host, e.g. `sudo nixos-rebuild boot --flake .#wsl`.
- Another distro gets a name of its own in `hosts` in `flake.nix`.

## GUI apps and scaling (WSLg)

GUI apps open as Windows windows, e.g. `kitty &`. WSLg doesn't scale Linux apps on high-DPI screens by default. To scale them like the Windows display setting, create `%USERPROFILE%\.wslgconfig` (the section name matters, `[system]` is ignored):

```ini
[system-distro-env]
WESTON_RDP_HI_DPI_SCALING=true
WESTON_RDP_FRACTIONAL_HI_DPI_SCALING=true
WESTON_RDP_DEBUG_DESKTOP_SCALING_FACTOR=150
```

Then restart WSL with `wsl --shutdown`. Alternatively, only enlarge kitty with `kitty.fontSize` in the Home Manager `theme.nix`.

## Troubleshooting

| Problem | Cause and fix |
|---|---|
| Rebuild fails with "path ... does not exist" | The file isn't tracked by git. `git add` it. |
| Rebuild fails with "flake ... does not provide attribute ... nixosConfigurations.&lt;name&gt;" | The hostname isn't a host in `flake.nix` (e.g. still `nixos` from before). Build once with `.#wsl`, see [Hosts](#hosts). |
| `git` refuses the repository ("dubious ownership") | `git config --global --add safe.directory <path>`, also with `sudo`. |
| "command not found" for zoxide, eza, fzf … after a rebuild | WSL is still running the old generation. Restart it, see [Setup](#setup) step 5. |
| GUI apps tiny | `.wslgconfig`, see [GUI apps and scaling](#gui-apps-and-scaling-wslg). |

## Applications

Every program has its own module in `applications/<group>/<program>/default.nix`, with a link to its website or documentation; the groups are by purpose. Programs with user settings also have a file in `home-manager/applications/<group>/`, in the same group.

| Group | Programs |
|---|---|
| `containers` | Docker, oxker (terminal UI for Docker containers) |
| `databases` | mssql-odbc (SQL Server ODBC drivers, see below) |
| `development` | git, direnv |
| `editors` | micro, nano, neovim (`nvim`), PyCharm |
| `files` | archives (zip, unzip, 7z), broot, eza, lsd, nnn, superfile (`spf`), yazi, zoxide (`z`, `zi`) |
| `languages` | Node.js, Python (see below) |
| `network` | curl, curlie, dnsutils (dig, nslookup), gping, httpie, rclone, wget |
| `search` | fd, fselect, fzf, ripgrep (`rg`) |
| `system` | btop, duf, dust, glances, htop, iotop, procs, system-tools (file, tree, lsof, lspci, lsusb) |
| `terminal` | kitty, mcfly, oh-my-posh (prompt), pay-respects (`fuck`), powerline, tealdeer (`tldr`), tmux |
| `text` | bat, choose, jq / yq |

`applications/development/direnv` loads a project's Nix dev shell when you enter its directory: `echo "use flake" > .envrc && direnv allow`.

`applications/languages/python` installs Python, Poetry, pipx and uv. The Python version (built from source, from the 3.x interpreter of nixpkgs with the same minor version), the Poetry version and the uv version are pinned in `vars.nix` (`packageVersions`). Poetry runs on its own Python from nixpkgs, but creates project environments with the pinned one. Its virtual environments go to `python.venvPath` in `vars.nix`, one folder per project; a project's `poetry.toml` or `poetry config virtualenvs.path` can still change that. Apps installed with `pipx install` run on the pinned Python, with their commands in `~/.local/bin` (on the `PATH`). uv uses the pinned Python too (`UV_PYTHON`) and never downloads one, since its downloaded Pythons don't run on NixOS; it keeps a project's environment in the project's `.venv`, and `uv tool install` puts commands in `~/.local/bin`. Python prints output unbuffered, writes no `__pycache__` and uses UTF-8 (`PYTHONUNBUFFERED`, `PYTHONDONTWRITEBYTECODE`, `PYTHONUTF8`); pip only installs into virtual environments (`PIP_REQUIRE_VIRTUALENV`); uv copies packages from its cache instead of hard-linking, which fails for projects under `/mnt/c` (`UV_LINK_MODE=copy`).

`applications/languages/nodejs` installs Node.js (the major version from `packageVersions.nodejs`) with npm and npx. `npm install -g` installs into `nodejs.npmGlobalPath` from `vars.nix`, whose `bin` folder is on the `PATH`. npm shows no funding or update notices.

`applications/databases/mssql-odbc` installs the Microsoft ODBC Driver 17 and 18 for SQL Server, for pyodbc (`pyodbc.drivers()`) and other ODBC clients, e.g. `DRIVER={ODBC Driver 18 for SQL Server};SERVER=...`. `odbcinst -q -d` lists them. pyodbc from PyPI needs `libodbc.so.2` and `libstdc++.so.6`, which programs built with Nix don't find on their own, so both are on `LD_LIBRARY_PATH` for every program.

### Nix housekeeping (`core/nix.nix`)

- **nh** removes old generations weekly, keeping the last 5 and everything from the last 14 days. `nh os switch` rebuilds like `nrs` and lists the changed packages; `nh clean all` cleans up right away.
- **Store optimisation** (`auto-optimise-store`) hard-links identical files.
- **nix-index** with a prebuilt weekly database (flake input `nix-index-database`): an unknown command suggests the package that has it, `, <program>` runs a program without installing it, and `nix-locate bin/<name>` searches all packages.

Docker (`applications/containers/docker`) uses `/28` address pools, and the user is in the `docker` group.

To add a program: create `applications/<category>/<program>/default.nix`, add it to the category's `default.nix` imports, `git add` it and rebuild.

## Commands

| Command | What it does |
|---|---|
| `sudo nixos-rebuild switch --flake .` | Apply the configuration of this host (alias `nrs`) |
| `sudo nixos-rebuild switch --flake .#<host>` | The same for a host by name, needed the first time in a distro |
| `sudo nixos-rebuild test --flake .` | Try it without making it the boot default |
| `nix flake update` | Update the system flake inputs |
| `nix-shell -p whois --run "mkpasswd -m sha-512"` | Generate a password hash for `vars.user.hashedPassword` |
| `sudo nixos-rebuild switch --rollback` | Go back to the previous system generation |

The aliases `nrs`, `nfr` (pull, rebuild system and user settings) and `hmr` (pull, rebuild user settings) come from the Home Manager template, see [home-manager/README.md](home-manager/README.md#aliases).
