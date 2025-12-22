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
  environment.systemPackages =
    with pkgs;
    lib.optionals (enableApp config.networking.hostName) [
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
      rocmPackages.rocm-core
      rocmPackages.rccl
      btop-rocm
    ];
}
