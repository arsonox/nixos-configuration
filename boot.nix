{ config, lib, pkgs, ... }:
{
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
