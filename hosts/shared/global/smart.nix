{ pkgs, ... }:

{
  services.smartd = {
    enable = true;
    notifications.systembus-notify.enable = true;
  };

  environment.systemPackages = with pkgs; [
    smartmontools
  ];
}
