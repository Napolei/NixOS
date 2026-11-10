# ==============================================================================
# Global Configuration Variables & Flags
# ==============================================================================
#
# This file centralizes system-wide parameters, user configurations, flags,
# and package settings reused across NixOS and user modules.
#
# USAGE:
# - In Flakes: Injected into all NixOS modules via `specialArgs` and `_module.args.vars`.
#   flake.nix imports it once per host, with that host's name.
# - In Modules: Access directly in module arguments `{ config, pkgs, lib, vars, ... }:`.
# - In Standalone files: Load via `let vars = import ./vars.nix { }; in ...`.
# ==============================================================================

{
  # Set per host in flake.nix (hosts)
  hostName ? "wsl",
}:

rec {
  # ----------------------------------------------------------------------------
  # System Defaults & Localization
  # ----------------------------------------------------------------------------
  system = {
    stateVersion = "26.05";
    timeZone = "Europe/Luxembourg";
    defaultLocale = "en_GB.UTF-8";
    keyboardLayout = "de";
  };

  # ----------------------------------------------------------------------------
  # Host (from flake.nix)
  # ----------------------------------------------------------------------------
  inherit hostName;

  # ----------------------------------------------------------------------------
  # User Accounts, IDs & Permissions
  # ----------------------------------------------------------------------------
  user = {
    username = "max";
    description = "Max";
    hashedPassword = "$6$xoSAID1DZpaQN820$66OeFpsJCLNre6rQQgXlPceDb4Y3oOK30dsAUjf.BoMFJTkyReXb4gOEFlLlIgkPN1BGuUd.skJL5IhD9ZAjA.";

    uid = 1000;
  };

  # ----------------------------------------------------------------------------
  # Application Feature Flags & Edition Selectors
  # ----------------------------------------------------------------------------
  jetbrains = {
    # Set to true to install PyCharm Professional instead of Community
    usePro = true;

    # Individual overrides (defaults to usePro if not explicitly overridden)
    pycharmEdition = if jetbrains.usePro then "professional" else "community";
  };

  python = {
    # Base folder of the virtual environments Poetry creates, one subfolder per
    # project. Expanded by the shell, so $HOME is each user's home folder.
    venvPath = "$HOME/.virtualenvs";
  };

  nodejs = {
    # Folder of the packages `npm install -g` installs (npm's prefix); its bin
    # folder is on the PATH. Expanded by the shell, like venvPath.
    npmGlobalPath = "$HOME/.npm-global";
  };

  # ----------------------------------------------------------------------------
  # Package Versions & Version Pinning
  # ----------------------------------------------------------------------------
  # Centralized location to specify target versions, commit revs, or flags
  # when pinning or overriding specific package builds.
  packageVersions = {
    # Python source releases and checksums:
    # - Source releases and SHA-256 checksums: https://www.python.org/downloads/source/
    # - Direct FTP directory: https://www.python.org/ftp/python/
    python = {
      version = "3.13.18";
      hash = "sha256:abb0102e6d4ae027509bcb82327d9dd85515b44a3ba8ad538cfc5e9847029f68";
    };

    # Poetry (applications/development/python), from its GitHub releases:
    # https://github.com/python-poetry/poetry/releases
    # poetry-core must be the version that Poetry release requires:
    # https://github.com/python-poetry/poetry-core/releases
    # Hashes are SRI hashes of the source archives; after changing a version,
    # set the hash to "" and copy the correct one from the build error.
    poetry = {
      version = "2.4.3";
      hash = "sha256-ZYOnjWmcmswyugay8RuO/adkKo8/P9Xj9ADmEt4IHCE=";
      core = {
        version = "2.4.0";
        hash = "sha256-i9EucMsoX8Z0iyhNDVYaczv1CSY/KaZpMjn/FGzIJU4=";
      };
    };

    # uv (applications/development/python), built from source like nixpkgs'
    # package: https://github.com/astral-sh/uv/releases
    # hash is the source archive's, cargoHash the Rust dependencies'; after
    # changing the version, set both to "" and copy each correct one from the
    # build errors (the source first). Another version than nixpkgs' isn't in
    # the binary cache, and compiling uv takes a while.
    uv = {
      version = "0.13.0";
      hash = "sha256-xuC7aRvs7Cz5kXBSl65atxoji5zk9ACNHAoHiljj8Oo=";
      cargoHash = "sha256-fGSkvK12wafGRSH2vmXrTncENwFNw0jTbKRXTwtnO9s=";
    };

    # Node.js major version (applications/development/nodejs): uses nixpkgs'
    # nodejs_<version>, the latest release of it. Release schedule (even
    # versions become LTS): https://nodejs.org/en/about/previous-releases
    nodejs = "24";
  };
}
