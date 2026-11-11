# Node.js with npm and npx. The major version is pinned in vars.nix
# (packageVersions.nodejs), the folder of global npm packages is
# vars.nodejs.npmGlobalPath.
# https://nodejs.org
# https://docs.npmjs.com

{ config, pkgs, lib, vars ? import ../../../vars.nix { }, ... }:

let
  # e.g. "24" -> nodejs_24, the latest release of that major version in nixpkgs
  nodejs = pkgs."nodejs_${vars.packageVersions.nodejs}";
in
{
  environment.systemPackages = [
    nodejs
  ];

  # `npm install -g` writes here instead of into the read-only Nix store; its
  # commands are on the PATH
  # https://docs.npmjs.com/cli/configuring-npm/folders#prefix-configuration
  environment.variables = {
    NPM_CONFIG_PREFIX = vars.nodejs.npmGlobalPath;
    # No funding and "new npm version" notices
    # https://docs.npmjs.com/cli/using-npm/config#fund
    NPM_CONFIG_FUND = "false";
    NPM_CONFIG_UPDATE_NOTIFIER = "false";
  };
  environment.extraInit = ''
    export PATH="${vars.nodejs.npmGlobalPath}/bin:$PATH"
  '';
}
