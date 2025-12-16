{ config, libs, pkgs, ... }:

{
  networking.hostName = "fwdesktop";

  imports = [
    ../configuration.nix
  ];
}
