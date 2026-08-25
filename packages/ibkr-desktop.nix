{
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,
  lib,
  # Runtime deps (bundled Zulu JRE + QtJambi/QtWebEngine)
  alsa-lib,
  atk,
  brotli,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  krb5,
  libdrm,
  libgbm,
  libGL,
  libglvnd,
  libpulseaudio,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxtst,
  mesa,
  nss,
  nspr,
  openssl,
  pango,
  qt6,
  stdenv,
  udev,
  vulkan-loader,
  wayland,
  xorg,
  zlib,
  zstd,
}:

let
  installerUrl = "https://download2.interactivebrokers.com/installers/ntws/latest-standalone/ntws-latest-standalone-linux-x64.sh";

  # Upstream ships an unversioned, auto-updating installer, so the app lives
  # in $HOME (writable, updater works) instead of the store: install on first
  # run, then just launch.
  launcher = writeShellScript "ibkr-desktop-launcher" ''
    set -eu
    dir="''${XDG_DATA_HOME:-$HOME/.local/share}/ibkr-desktop"
    if [ ! -x "$dir/ntws" ]; then
      echo "IBKR Desktop not installed yet, downloading installer..."
      tmp=$(mktemp /tmp/ntws-installer-XXXXXX.sh)
      trap 'rm -f "$tmp"' EXIT
      curl -fL -o "$tmp" ${installerUrl}
      sh "$tmp" -q -dir "$dir"
    fi
    exec "$dir/ntws" "$@"
  '';

  desktopItem = makeDesktopItem {
    name = "ibkr-desktop";
    desktopName = "IBKR Desktop";
    comment = "Interactive Brokers trading platform";
    exec = "ibkr-desktop %U";
    icon = "/home/nox/.local/share/ibkr-desktop/.install4j/ntws.png";
    categories = [ "Office" "Finance" ];
    startupWMClass = "install4j-launcher-Main";
  };
in
buildFHSEnv {
  name = "ibkr-desktop";

  targetPkgs = pkgs: [
    alsa-lib
    atk
    brotli
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    krb5
    libdrm
    libgbm
    libGL
    libglvnd
    libpulseaudio
    libx11
    libxcb
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-util
    libxcb-wm
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxtst
    mesa
    nss
    nspr
    openssl
    pango
    stdenv.cc.cc.lib
    udev
    vulkan-loader
    wayland
    xorg.libxkbfile
    xorg.libxshmfence
    zlib
    zstd
    qt6.qtwayland
  ];

  profile = ''
    export QT_QPA_PLATFORM=xcb
    unset WAYLAND_DISPLAY
  '';

  runScript = "${launcher}";

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/*.desktop -t $out/share/applications
  '';

  meta = {
    description = "IBKR Desktop trading platform (FHS wrapper, installs to ~/.local/share/ibkr-desktop on first run)";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
