{ pkgs, lib, ... }:

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
    protonup-qt
    powertop
    ethtool
    v4l-utils
    usbutils
    mpv
  ];
}
