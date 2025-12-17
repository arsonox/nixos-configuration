{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    # noto-fonts-color-emoji
    twemoji-color-font
    vista-fonts
  ];
}
