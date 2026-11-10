# jq / yq: query and edit JSON, YAML and TOML on the command line
# https://jqlang.org
# https://github.com/mikefarah/yq

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    jq
    yq-go
  ];
}
