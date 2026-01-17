{
  lib,
  pkgs,
  config,
  ...
}:

let
  # Custom Discord profile for NixOS that doesn't use restrictive private-* directives
  discordProfile = pkgs.writeText "discord-nixos.profile" ''
    # Custom Discord profile for NixOS
    noblacklist ''${HOME}/.config/discord

    mkdir ''${HOME}/.config/discord
    whitelist ''${HOME}/.config/discord
    whitelist ''${HOME}/Downloads
    whitelist ''${HOME}/Pictures

    # Network access
    netfilter

    # D-Bus notifications and screen sharing
    dbus-user filter
    dbus-user.talk org.freedesktop.Notifications
    dbus-user.talk org.freedesktop.portal.Desktop
    dbus-user.talk org.freedesktop.portal.Documents
    dbus-user.talk org.freedesktop.portal.ScreenCast
    dbus-user.talk org.freedesktop.portal.RemoteDesktop
    dbus-user.talk org.freedesktop.portal.Camera

    # D-Bus system tray
    dbus-user.talk org.kde.StatusNotifierWatcher

    # Allow video devices for webcam and capture cards
    noblacklist /dev/video*
    noblacklist /sys/devices
    noblacklist /sys/class/video4linux
    read-only /sys/devices
    read-only /sys/class/video4linux

    # Allow audio devices for microphone and audio input
    noblacklist /dev/snd

    # PipeWire support for media streaming
    noblacklist /run/user/*/pipewire-*
    noblacklist /dev/dri

    # Additional device access for capture cards
    noblacklist /dev/media*
    noblacklist /dev/v4l-subdev*
    noblacklist /sys/bus
    noblacklist /sys/dev
    read-only /sys/bus
    read-only /sys/dev

    # Basic protections
    nonewprivs
    noroot
    protocol unix,inet,inet6,netlink
    seccomp
  '';

  # Wrapper for Discord that disables Chrome's internal sandbox (firejail provides sandboxing)
  discordWrapper = pkgs.writeShellScript "discord-wrapper" ''
    exec ${lib.getBin pkgs.discord}/bin/discord --no-sandbox "$@"
  '';

  # Custom Gajim profile for NixOS compatibility
  gajimProfile = pkgs.writeText "gajim-nixos.profile" ''
    # Custom Gajim profile for NixOS
    noblacklist ''${HOME}/.gnupg
    noblacklist ''${HOME}/.cache/gajim
    noblacklist ''${HOME}/.config/gajim
    noblacklist ''${HOME}/.local/share/gajim

    mkdir ''${HOME}/.gnupg
    mkdir ''${HOME}/.cache/gajim
    mkdir ''${HOME}/.config/gajim
    mkdir ''${HOME}/.local/share/gajim
    whitelist ''${HOME}/.gnupg
    whitelist ''${HOME}/.cache/gajim
    whitelist ''${HOME}/.config/gajim
    whitelist ''${HOME}/.local/share/gajim
    whitelist ''${HOME}/Downloads

    # Network access
    netfilter

    # D-Bus for Gajim functionality
    dbus-user filter
    dbus-user.own org.gajim.Gajim
    dbus-user.talk org.freedesktop.Notifications
    dbus-user.talk org.freedesktop.secrets
    dbus-user.talk ca.desrt.dconf
    dbus-user.talk org.kde.StatusNotifierWatcher
    dbus-user.talk com.canonical.indicator.application
    dbus-user.talk org.ayatana.indicator.application
    dbus-system filter
    dbus-system.talk org.freedesktop.login1

    # Basic protections
    caps.drop all
    nodvd
    nogroups
    noinput
    nonewprivs
    noroot
    notv
    nou2f
    protocol unix,inet,inet6,netlink
    seccomp
  '';

  # Custom mpv profile for NixOS compatibility
  mpvProfile = pkgs.writeText "mpv-nixos.profile" ''
    # Custom mpv profile for NixOS
    noblacklist ''${HOME}/.config/mpv
    noblacklist ''${HOME}/.cache/mpv

    mkdir ''${HOME}/.config/mpv
    mkdir ''${HOME}/.cache/mpv
    whitelist ''${HOME}/.config/mpv
    whitelist ''${HOME}/.cache/mpv
    whitelist ''${HOME}/Downloads
    whitelist ''${HOME}/Videos
    whitelist ''${HOME}/Music

    # Network access for streaming
    netfilter

    # Hardware acceleration and video output
    noblacklist /dev/dri
    noblacklist /dev/video*
    noblacklist /sys/devices
    noblacklist /sys/class/video4linux
    read-only /sys/devices
    read-only /sys/class/video4linux

    # Audio devices
    noblacklist /dev/snd

    # PipeWire support
    noblacklist /run/user/*/pipewire-*

    # D-Bus for MPRIS and notifications
    dbus-user filter
    dbus-user.talk org.freedesktop.Notifications
    dbus-user.talk org.mpris.MediaPlayer2.*

    # Basic protections
    caps.drop all
    nonewprivs
    noroot
    protocol unix,inet,inet6,netlink
    seccomp
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
        profile = discordProfile;
      };
      Discord = {
        executable = "${discordWrapper}";
        profile = discordProfile;
      };

      gajim = {
        executable = lib.getExe pkgs.gajim;
        profile = gajimProfile;
      };

      mpv = {
        executable = lib.getExe pkgs.mpv;
        profile = mpvProfile;
      };

    };
  };
}
