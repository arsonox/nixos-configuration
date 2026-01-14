{
  lib,
  pkgs,
  config,
  ...
}:

let
  # Wrapper for Discord that disables Chrome's internal sandbox (firejail provides sandboxing)
  discordWrapper = pkgs.writeShellScript "discord-wrapper" ''
    exec ${lib.getBin pkgs.discord}/bin/discord --no-sandbox "$@"
  '';
in
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

      # Use wrapper script to pass --no-sandbox to Electron
      discord = {
        executable = "${discordWrapper}";
        profile = ./firejail-profiles/discord.profile;
      };
      Discord = {
        executable = "${discordWrapper}";
        profile = ./firejail-profiles/discord.profile;
      };

      gajim = {
        executable = lib.getExe pkgs.gajim;
        profile = ./firejail-profiles/gajim.profile;
      };

      mpv = {
        executable = lib.getExe pkgs.mpv;
        profile = ./firejail-profiles/mpv.profile;
      };
      umpv = {
        executable = lib.getExe' pkgs.mpv "umpv";
        profile = ./firejail-profiles/mpv.profile;
      };

    };
  };
}
