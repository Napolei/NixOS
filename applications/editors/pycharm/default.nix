{ config, pkgs, lib, vars, ... }:

let
  pycharmPkg = if (vars.jetbrains.pycharmEdition or (if vars.jetbrains.usePro or false then "professional" else "community")) == "professional"
    then pkgs.jetbrains.pycharm
    else pkgs.jetbrains.pycharm-community;
in
{
  environment.systemPackages = [
    pycharmPkg
  ];
}
