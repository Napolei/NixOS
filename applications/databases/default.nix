# Aggregator module for database drivers and clients

{ config, pkgs, lib, ... }:

{
  imports = [
    ./mssql-odbc
  ];
}
