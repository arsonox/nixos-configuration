{ config, libs, pkgs, ... }:

{
  networking.hostName = "nixos";

  imports = [
    ../configuration.nix
  ];
}
