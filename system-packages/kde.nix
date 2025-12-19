{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  environment.systemPackages = with pkgs.kdePackages; [
    discover
    sddm-kcm
    kcolorchooser
    krdc
  ];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      m17n
      table
      table-others
    ];
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];
}
