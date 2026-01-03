{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    rocmPackages.rocm-core
    rocmPackages.rccl
    btop-rocm
  ];
}
