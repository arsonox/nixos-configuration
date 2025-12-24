{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #oreo-cursors-plus
    bibata-cursors
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 22;
      };
      iconTheme = "Breeze Chameleon Dark";
      wallpaper = /etc/nixos/assets/GyRo9sDWEAAIrql.jpg;
    };

    kscreenlocker = {
      appearance.wallpaper = /etc/nixos/assets/castorice-purple.jpg;
    };

    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Alt+K";
      command = "konsole";
    };

    input = {
      keyboard.layouts = [
        {
          layout = "us";
          variant = "intl";
        }
      ];
    };

    panels = [
      {
        location = "top";
        height = 27;
        opacity = "translucent";
        floating = true;
        widgets = [
          {
            kicker = {
              icon = "application-menu-symbolic";
            };
          }
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.volume"
              ];
              hidden = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.weather"
                "org.kde.plasma.battery"
                "org.kde.plasma.brightness"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.notifications"
              ];
            };
          }
          {
            digitalClock = {
              calendar = {
                firstDayOfWeek = "monday";
                showWeekNumbers = true;
              };
              time.format = "24h";
              date.format = "isoDate";
            };
          }
        ];
      }
      {
        location = "bottom";
        height = 44;
        opacity = "translucent";
        lengthMode = "fit";
        floating = true;
        hiding = "dodgewindows";
        widgets = [
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:org.kde.konsole.desktop"
              ];
            };
          }
        ];
      }
    ];

    configFile = {
      kwinrc.Desktops.Number = {
        value = 1;
        immutable = true;
      };
    };

  };
}
