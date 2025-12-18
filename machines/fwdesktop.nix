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

  services.power-profiles-daemon.enable = false;

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
    };
  };

  powerManagement.powertop.enable = true;

  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  #hardware.system76.power-daemon.enable = true;
  #services.system76-scheduler.enable = true;

  #services.auto-cpufreq.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  imports = [
    ./fwdesktop-hw.nix
    ../configuration.nix
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];
}
