{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    clamav
  ];

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.frequency = 12; # Number of database checks per day
    scanner = {
      enable = true;
      interval = "daily";
      scanDirectories = [
        "/home"
        "/var/lib"
        "/tmp"
        "/etc"
        "/var/tmp"
      ];
    };
  };
}
