{ pkgs, osConfig, ... }:

{
  programs.lutris = {
    enable = true;
    protonPackages = with pkgs; [ proton-ge-bin ];
    steamPackage = osConfig.programs.steam.package;
  };
}
