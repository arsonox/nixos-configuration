{ config, pkgs, inputs, ... }:

let
  #nur = inputs.nur;
in
{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.systemPackages = with pkgs; [
    nur.repos.ataraxiasjel.waydroid-script
  ];
}
