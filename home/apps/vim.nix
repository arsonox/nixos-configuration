{ ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      expandtab = true;
      tabstop = 2;
      number = true;
      relativenumber = true;
    };
    extraConfig = ''
      set smartindent
      set showmatch
      set backspace=indent,eol,start
      syntax on
    '';
  };
}
