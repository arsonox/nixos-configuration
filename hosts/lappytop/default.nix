{ ... }:

{
  networking.hostName = "lappytop";

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

      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 25;
    };
  };

  zramSwap = {
    writebackDevice = "/dev/nvme0n1p2";
  };

  hardware.amdgpu.initrd.enable = true;

  imports = [
    ./lappytop-hw.nix
    ../shared
  ];

  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
    "modesetting"
  ];
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    offload.enable = true;

    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
