# Aggregator module for development IDEs and tools

{ config, pkgs, lib, ... }:

{
  imports = [
    ./direnv
    ./docker
    ./git
    ./mssql-odbc
    ./nodejs
    ./oxker
    ./pycharm
    ./python
  ];
}
