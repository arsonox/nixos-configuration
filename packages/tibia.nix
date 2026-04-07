{
  buildFHSEnv,
  makeDesktopItem,
  lib,
  # Runtime deps
  alsa-lib,
  brotli,
  dbus,
  expat,
  fontconfig,
  freetype,
  libdrm,
  libGL,
  libglvnd,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxcrypt,
  libxrandr,
  libxtst,
  mesa,
  nss,
  nspr,
  openssl,
  qt6,
  stdenv,
  vulkan-loader,
  wayland,
  zlib,
}:

let
  desktopItem = makeDesktopItem {
    name = "tibia";
    desktopName = "Tibia";
    comment = "Tibia MMORPG client";
    exec = "tibia";
    icon = "/home/nox/Games/Tibia/tibia.ico";
    categories = [ "Game" ];
  };
in
buildFHSEnv {
  name = "tibia";

  targetPkgs = pkgs: [
    alsa-lib
    brotli
    dbus
    expat
    fontconfig
    freetype
    libdrm
    libGL
    libglvnd
    libx11
    libxcb
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-util
    libxcb-wm
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxcrypt
    libxrandr
    libxtst
    mesa
    nss
    nspr
    openssl
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
    zlib
    qt6.qtwayland
  ];

  profile = ''
    export QT_FONT_DPI=192
    export QT_QPA_PLATFORM=xcb
    unset WAYLAND_DISPLAY
  '';

  runScript = "/home/nox/Games/Tibia/Tibia";

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/*.desktop -t $out/share/applications
  '';

  meta = {
    description = "Tibia MMORPG client (FHS wrapper)";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
