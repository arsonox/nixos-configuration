{
  pkgs,
  ...
}:

{
  environment.systemPackages = [ pkgs.elgato4k-linux ];
  services.udev.packages = [ pkgs.elgato4k-linux ];
}
