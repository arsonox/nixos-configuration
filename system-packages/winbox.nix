{ config, pkgs, ... }:

{
  programs.winbox = {
    enable = true;
    openFirewall = true;
  };
}
