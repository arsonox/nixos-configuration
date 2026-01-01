{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  environment.systemPackages =
    with pkgs.kdePackages;
    with pkgs;
    [
      discover
      sddm-kcm
      kcolorchooser
      krdc
      kgpg
      kgamma
      plasma-wallpaper-application
      plasma-smart-video-wallpaper-reborn
    ];

  #ibus is required for us alt-intl input for the gtk snowflakes since 4.20+.
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
