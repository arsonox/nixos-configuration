{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override { embeddedTheme = "purple_leaves"; };
in
{
  environment.systemPackages = [
    sddm-astronaut
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ sddm-astronaut ];
  };
}
