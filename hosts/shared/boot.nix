{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Workaround: v4l2loopback 0.15.4 runs depmod into its own output, so its
  # modules.* index files collide with the kernel's in aggregateModules.
  # Patched in the kernel package set so programs.obs-studio.enableVirtualCamera
  # picks it up too. Fixed upstream by NixOS/nixpkgs#575861 (merged 2026-10-21);
  # remove this once nixos-unstable includes it.
  nixpkgs.overlays = [
    (final: prev: {
      linuxPackages_latest = prev.linuxPackages_latest.extend (
        kfinal: kprev: {
          v4l2loopback = kprev.v4l2loopback.overrideAttrs (old: {
            installFlags = (old.installFlags or []) ++ ["DEPMOD=true"];
          });
        }
      );
    })
  ];

  # 1792627200 = 2026-10-22T00:00Z, after the fix merged to master.
  warnings = pkgs.lib.optional (inputs.nixpkgs.lastModified >= 1792627200) ''
    hosts/shared/boot.nix: nixpkgs is now newer than NixOS/nixpkgs#575861.
    Try dropping the v4l2loopback modules.* override and using plain
    v4l2loopback.out again.
  '';

  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];

    kernelModules = [
      "v4l2loopback"
      "snd-aloop"
    ];

    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 exclusive_caps=1 card_label="OBS Cam"
    '';

    kernelParams = [
      "quiet"
      "initremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    kernel = {
      sysctl = {
        "vm.swappiness" = 100;
      };
    };

    plymouth.enable = true;
    plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
    plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  };
}
