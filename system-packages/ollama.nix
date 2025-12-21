{
  pkgs,
  lib,
  config,
  ...
}:

let
  # which hosts we install this on
  enabledHosts = [
    "fwdesktop"
  ];
  enableApp = hostname: builtins.elem hostname enabledHosts;
in
{
  services.ollama = lib.mkIf (enableApp config.networking.hostName) {
    enable = true;
    package = pkgs.ollama-rocm;
    #acceleration = "rocm";
    loadModels = [ "deepseek-coder-v2" ];
  };
}
