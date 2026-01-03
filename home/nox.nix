{
  lib,
  ...
}:

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

  imports = with lib; filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive ./apps);
}
