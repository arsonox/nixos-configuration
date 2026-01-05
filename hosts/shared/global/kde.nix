{
  pkgs,
  ...
}:

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
    ];

  programs.kdeconnect.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];
}
