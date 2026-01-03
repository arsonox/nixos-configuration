{
  ...
}:

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

  # Use TLP to set the power profile to "performance". This is not a laptop
  # so we don't need to think about preserving out battery.
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

  # Disable usb autosuspend entirely. This is causing some weird issues.
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "amd_pstate=active"
  ];

  # Enable tmpfs for /tmp. This is not enabled by default because Nix might run
  # out of space for compilation.
  boot.tmp.useTmpfs = true;

  hardware.amdgpu.initrd.enable = true;

  imports = [
    ./fwdesktop-hw.nix
    ../shared
    ./services
  ];

  # Add a swapfile for now, but this might be removed at a later date if it is
  # deemed unnecessary.
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
