{ config, libs, pkgs, ... }:

{

  networking.hostName = "fwdesktop";

  # nixpkgs.hostPlatform = {
  #   gcc.arch = "znver5";
  #   gcc.tune = "znver5";
  #   system = "x86_64-linux";
  # };
  
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "schedutil";
  };

  hardware.system76.power-daemon.enable = true;
  services.system76-scheduler.enable = true;

  #services.auto-cpufreq.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  imports = [
    ./fwdesktop-hw.nix
    ../configuration.nix
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];
}
