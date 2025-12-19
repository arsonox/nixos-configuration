{ config, pkgs, ... }:

{
  #home.sessionVariables = {
  #  ENHANCD_FILTER = "fzf --height 40%";
  #};
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      update = "sudo nixos-rebuild switch";
      upgrade = "sudo nix flake update && update";
      uptest = "sudo nixos-rebuild test";
      micreset = "sudo usbreset 046d:0ab7";
    };
    history.size = 100;

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ from:github ]; }
        { name = "zsh-users/zsh-history-substring-search"; tags = [ from:github defer:2 ]; }
        { name = "djui/alias-tips"; tags = [ from:github ]; }
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
        { name = "Seinh/git-prune"; tags = [ from:github ]; }
        { name = "supercrabtree/k"; tags = [ from:github ]; }
        # { name = "babarot/enhancd"; tags = [ use:init.sh ]; }
        { name = "mollifier/anyframe" ;}
        { name = "mafredri/zsh-async"; tags = [ from:github ]; }
        { name = "sindresorhus/pure"; tags = [ use:pure.zsh from:github as:theme ]; }
      ];
    };
  };
}
