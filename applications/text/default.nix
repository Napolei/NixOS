# Aggregator module for viewing and processing text and structured data

{ config, pkgs, lib, ... }:

{
  imports = [
    ./bat
    ./choose
    ./jq
  ];
}
