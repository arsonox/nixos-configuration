{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    # noto-fonts-color-emoji
    twemoji-color-font
    vista-fonts
    open-sans
    dejavu_fonts
    ipafont
  ];
}
