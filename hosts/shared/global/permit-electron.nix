{
  lib,
  ...
}:

lib.warn "electron 39.8.10 is permitted as insecure package" {
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
}
