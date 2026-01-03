{
  pkgs,
  osConfig,
  ...
}:

{
  programs.lutris = {
    enable = true;
    protonPackages = [ pkgs.proton-ge-bin ];
    steamPackage = osConfig.programs.steam.package;
  };
}
