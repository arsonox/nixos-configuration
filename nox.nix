{ config, pkgs, lib, ... }:

{
  home.username = "nox";
  home.homeDirectory = "/home/nox";
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      la = "ls -la";
    };
  };

 # programs.vim = {
 #   enable = true;
 #   settings = {
 #     expandtab = true;
 #     tabstop = 2;
 #     number = true;
 #     relativenumber = true;
 #   };
 #   extraConfig = ''
 #     set smartindent
 #     set showmatch
 #     set backspace=indent,eol,start
 #     syntax on
 #   '';
 # };

  imports = lib.filter
    (n: lib.strings.hasSuffix ".nix" n)
    (lib.filesystem.listFilesRecursive ./apps);
}
