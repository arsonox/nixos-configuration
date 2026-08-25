{
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,
  writeShellScriptBin,
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

  # Opening URLs directly would exec the host browser inside the sandbox,
  # where its firejail wrapper crashes; hand them to the desktop portal instead.
  xdgOpenShim = writeShellScriptBin "xdg-open" ''
    exec ${lib.getBin glib}/bin/gdbus call --session \
      --dest org.freedesktop.portal.Desktop \
      --object-path /org/freedesktop/portal/desktop \
      --method org.freedesktop.portal.OpenURI.OpenURI \
      "" "$1" "{}" > /dev/null
  '';

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
    # The app caches an absolute browser path in jts.ini, bypassing $BROWSER;
    # pin it to the portal shim so URL clicks escape the sandbox.
    ini="$HOME/ntws/jts.ini"
    if grep -q '^linux_browser=' "$ini" 2>/dev/null; then
      sed -i 's|^linux_browser=.*|linux_browser=/usr/bin/xdg-open|' "$ini"
    else
      printf '\n[browser]\nlinux_browser=/usr/bin/xdg-open\n' >> "$ini"
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
    xdgOpenShim
  ];

  profile = ''
    export QT_QPA_PLATFORM=xcb
    unset WAYLAND_DISPLAY
    export BROWSER=xdg-open
    # Hybrid graphics: render on the NVIDIA dGPU where one exists
    if [ -e /proc/driver/nvidia ]; then
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
    fi
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
