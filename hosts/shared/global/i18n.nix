{
  pkgs,
  ...
}:

{
  #u18n is required for us alt-intl input for the gtk snowflakes since 4.20+.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        # fcitx5-m17n
        # fcitx5-configtool
      ];
    };
  };
}
