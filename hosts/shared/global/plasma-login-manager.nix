{
  ...
}:

{
  services.displayManager.plasma-login-manager.enable = true;

  environment.etc."xdg/plasmaloginrc".text = ''
    [Greeter]
    Background=${../../../wallpapers/castorice-purple.jpg}
  '';
}
