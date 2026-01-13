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
        executable = "${lib.getBin pkgs.firefox}/bin/firefox";
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
        executable = "${lib.getBin pkgs.discord}/bin/Discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
      };

      gajim = {
        executable = "${lib.getBin pkgs.gajim}/bin/gajim";
        profile = "${pkgs.firejail}/etc/firejail/gajim.profile";
      };

      telegram-desktop = {
        executable = "${lib.getBin pkgs.telegram-desktop}/bin/Telegram";
        profile = "${pkgs.firejail}/etc/firejail/telegram.profile";
      };

      mpv = {
        executable = "${lib.getBin pkgs.mpv}/bin/mpv";
        profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
      };

    };
  };
}
