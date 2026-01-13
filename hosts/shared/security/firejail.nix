{
  lib,
  pkgs,
  config,
  ...
}:

{
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      firefox = {
        executable = lib.getExe pkgs.firefox;
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        extraArgs = [
          # Enable AppArmor confinement
          "--apparmor"
          # Required for U2F/FIDO2 YubiKey support
          "--ignore=private-dev"
          "--ignore=nou2f"
          # Add access to the Downloads folder
          "--whitelist=${config.users.users.nox.home}/Downloads"
        ];
      };

      # TODO: figure out if I need to keep both capitalised and non-capitalised
      # executable names for Discord. Technically they both link to the same
      # binary under ${pkgs.discord}/opt/Discord so perhaps using that as
      # the executable here would work?
      discord = {
        executable = "${lib.getBin pkgs.discord}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      };
      Discord = {
        executable = lib.getExe pkgs.discord;
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      };

      gajim = {
        executable = lib.getExe pkgs.gajim;
        profile = "${pkgs.firejail}/etc/firejail/gajim.profile";
      };

      telegram-desktop = {
        executable = lib.getExe pkgs.telegram-desktop;
        profile = "${pkgs.firejail}/etc/firejail/telegram.profile";
      };

      mpv = {
        executable = lib.getExe pkgs.mpv;
        profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
      };

    };
  };
}
