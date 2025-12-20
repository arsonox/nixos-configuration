{ config, pkgs, nur, ... }:

{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.systemPackages = [
    nur.repos.ataraxiasjel.waydroid-script
  ];
}
