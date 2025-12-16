{ config, libs, pkgs, ... }:

{

  networking.hostName = "fwdesktop";

  # nixpkgs.hostPlatform = {
  #   gcc.arch = "znver5";
  #   gcc.tune = "znver5";
  #   system = "x86_64-linux";
  # };
  
  powerManagement.enable = true;
  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   charger = {
  #     governor = "performance";
  #     turbo = "auto";
  #   };
  # };

  boot.initrd.kernelModules = [ "amdgpu" ];

  imports = [
    ./fwdesktop-hw.nix
    ../configuration.nix
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  # hardware.graphics.extraPackages = with pkgs; [
  #   amdvlk
  # ];

  # hardware.graphics.extraPackages32 = with pkgs; [
  #   driversi686Linux.amdvlk
  # ];
}
