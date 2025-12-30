{ pkgs, ... }:

{
  home.packages = with pkgs; [ git-crypt ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Nox";
        email = "1620870+arsonox@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      safe.directory = [
        "/etc/nixos"
        "/etc/nixos/assets"
        "/home/nox/.dotfiles"
      ];

      config = {
        push = {
          autoSetupRemote = true;
        };
      };
    };
  };
}
