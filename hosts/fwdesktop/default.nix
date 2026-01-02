{ pkgs, lib, ... }:

{
  networking.hostName = "fwdesktop";

  nix.settings.system-features = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
    "gccarch-znver5"
  ];

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
    ../shared
    ./services
  ];

  environment.systemPackages = with pkgs; [
    framework-tool
    framework-tool-tui
  ];

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024; # 16GiB
      priority = 1;
    }
  ];

  services.xserver.videoDrivers = [
    "amdgpu"
    "modesetting"
  ];
}
