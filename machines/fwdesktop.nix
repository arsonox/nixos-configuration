{ pkgs, ... }:

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

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      USB_AUTOSUSPEND = 0;
    };
  };

  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "amd_pstate=active"
  ];

  hardware.amdgpu.initrd.enable = true;

  imports = [
    ./fwdesktop-hw.nix
    ../configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    framework-tool
    framework-tool-tui
  ];

  services.xserver.videoDrivers = [
    "amdgpu"
    "modesetting"
  ];
}
