{
  inputs,
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
    proton-vpn
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
    yt-dlp
    iperf3
    mission-center
    jq
    nixd
    nixfmt
    nil
    package-version-server
    go
    gopls
    inputs.lmstudio.packages.${pkgs.stdenv.hostPlatform.system}.default
    trezor-suite
    trezord
    appflowy
    btrfs-assistant
    bitwarden-desktop
    duf
    gping
    asm-lsp
    signal-desktop
    fluffychat
    tibia
    ibkr-desktop
    runelite
    bottles
    inputs.hytale-launcher.packages.x86_64-linux.default
  ];
}
