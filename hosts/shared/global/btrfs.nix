{
  pkgs,
  ...
}:

{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];
}
