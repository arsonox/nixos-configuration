{ config, pkgs, ... }:
{
    users.users.nox = {
    isNormalUser = true;
    description = "nox";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      lutris
      moonlight-qt
      fzf
      discord
      gajim
      telegram-desktop
    ];
  };
}
