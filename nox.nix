{ config, pkgs, lib, ... }:

{
  home.username = "nox";
  home.homeDirectory = "/home/nox";
  home.stateVersion = "25.11";
  programs.bash.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  imports = lib.filter
    (n: lib.strings.hasSuffix ".nix" n)
    (lib.filesystem.listFilesRecursive ./apps);
}
