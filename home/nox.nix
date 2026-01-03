{
  lib,
  ...
}:

{
  home.username = "nox";
  home.homeDirectory = "/home/nox";
  home.stateVersion = "25.11";
  programs.bash.enable = true;

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/home/nox/.bitwarden-ssh-agent.sock";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  imports = with lib; filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive ./apps);
}
