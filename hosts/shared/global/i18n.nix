{
  pkgs,
  lib,
  ...
}:

rec {
  #u18n is required for us alt-intl input for the gtk snowflakes since 4.20+.
  i18n.inputMethod = {
    enable = true;
    # type = "fcitx5";
    type = "ibus";
    fcitx5 = lib.mkIf (i18n.inputMethod.type == "fcitx5") {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        qt6Packages.fcitx5-qt
        # fcitx5-m17n
        # fcitx5-configtool
      ];
    };
  };

  environment.variables =
    if i18n.inputMethod.type == "ibus" then
      {
        GTK_IM_MODULE = lib.mkForce null;
        QT_IM_MODULE = lib.mkForce null;
      }
    else
      {
        XMODIFIERS = "@im=fcitx";
      };
}
