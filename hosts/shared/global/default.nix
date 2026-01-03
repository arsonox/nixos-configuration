{
  pkgs,
  lib,
  ...
}:

{
  # Import all packages from this directory
  imports = builtins.filter (lib.strings.hasSuffix ".nix") (
    map toString (builtins.filter (p: p != ./default.nix) (lib.filesystem.listFilesRecursive ./.))
  );

  environment.systemPackages = with pkgs; [
    vim
    wget
    libsForQt5.qtstyleplugin-kvantum
    tealdeer
    python3
    wayland-utils
    streamcontroller
    wireguard-tools
    protonvpn-gui
    powertop
    ethtool
    v4l-utils
    usbutils
    mpv
    lutris
    moonlight-qt
    fzf
    discord
    gajim
    telegram-desktop
    winbox4
    wakelan
    haruna
    yt-dlp
    ungoogled-chromium
    iperf3
    mission-center
    jq
    nixd
    nixfmt
    nil
    package-version-server
    go
    gopls
    lmstudio
    trezor-suite
    trezord
    appflowy
    btrfs-assistant
    bitwarden-desktop
  ];
}
