{
  config,
  pkgs,
  lib,
  ...
}:

{
  systemd.services.tmpfs-monitor = {
    description = "Monitor /tmp tmpfs disk usage";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "tmpfs-monitor" ''
        # Get the disk usage percentage for /tmp (without the % sign)
        USAGE=$(${pkgs.coreutils}/bin/df /tmp | ${pkgs.gawk}/bin/awk 'NR==2 {print $5}' | ${pkgs.gnused}/bin/sed 's/%//')

        # Define thresholds
        THRESHOLD_WARNING=80
        THRESHOLD_CRITICAL=90

        # Get the actual size used and available
        SIZE_INFO=$(${pkgs.coreutils}/bin/df -h /tmp | ${pkgs.gawk}/bin/awk 'NR==2 {print $3 " used of " $2}')

        # Send notification based on usage
        if [ "$USAGE" -ge "$THRESHOLD_CRITICAL" ]; then
          ${pkgs.libnotify}/bin/notify-send \
            --urgency=critical \
            --icon=dialog-warning \
            "Critical: /tmp almost full" \
            "/tmp is $USAGE% full ($SIZE_INFO)\nConsider remounting a larger tmpfs"
        elif [ "$USAGE" -ge "$THRESHOLD_WARNING" ]; then
          ${pkgs.libnotify}/bin/notify-send \
            --urgency=normal \
            --icon=dialog-information \
            "Warning: /tmp getting full" \
            "/tmp is $USAGE% full ($SIZE_INFO)"
        fi
      '';
    };
  };

  systemd.timers.tmpfs-monitor = {
    description = "Timer for /tmp tmpfs monitoring";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
      Unit = "tmpfs-monitor.service";
    };
  };
}
