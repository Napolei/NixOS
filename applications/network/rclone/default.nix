# rclone: sync files with cloud storage (S3, Google Drive, WebDAV, ...)
# https://rclone.org/docs/ (https://github.com/rclone/rclone)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    rclone
  ];
}
