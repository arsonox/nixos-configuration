{ config, pkgs, lib, osConfig, ... }:

let
  # which hosts we install this on
  enabledHosts = [
    "fwdesktop"
  ];
  enableApp = hostname: builtins.elem hostname enabledHosts;
in
{
  # services.ollama = lib.mkIf (enableApp osConfig.networking.hostName) {
  #   enable = true;
  #   acceleration = "rocm";
  #   # loadModels = [ ];
  # };
}
