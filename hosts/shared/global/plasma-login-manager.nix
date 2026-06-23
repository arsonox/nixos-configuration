{
  ...
}:

{
  services.displayManager.plasma-login-manager.enable = true;

  environment.etc."plasmalogin.conf".text = ''
    [Greeter][Wallpaper][org.kde.image][General]
    Image=file://${../../../wallpapers/castorice-purple.jpg}
  '';
}
