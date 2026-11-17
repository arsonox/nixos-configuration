{
  config,
  ...
}:

let
  keychron-battery = config.boot.kernelPackages.callPackage ../../../packages/keychron-battery { };
in
{
  # Expose the Keychron mouse battery (TurboLink 8K receiver) to UPower/KDE
  # as /sys/class/power_supply/keychron_mouse.
  boot.extraModulePackages = [ keychron-battery ];
  boot.kernelModules = [ "keychron_battery" ];
}
