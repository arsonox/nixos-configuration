{
  pkgs,
  ...
}:

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
      wallpaper = "${../../wallpapers/evernight.jpg}";
    };

    kscreenlocker = {
      appearance.wallpaper = ../../wallpapers/castorice-purple.jpg;
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

    window-rules = [
      {
        description = "Window settings for mpv-wallpaper";
        match = {
          window-class = {
            value = "mpv mpv";
            type = "exact";
          };
          title = {
            value = "mpv-wallpaper";
            type = "exact";
          };
          window-types = [ "normal" ];
        };
        apply = {
          below = {
            value = true;
            apply = "force";
          };
          skiptaskbar = {
            value = true;
            apply = "force";
          };
          skippager = {
            value = true;
            apply = "force";
          };
          noborder = {
            value = true;
            apply = "force";
          };
          fpplevel = {
            value = 4;
            apply = "force";
          };
          acceptfocus = {
            value = false;
            apply = "force";
          };
        };
      }
    ];

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
                "applications:dev.zed.Zed.desktop"
                "applications:com.moonlight_stream.Moonlight.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.trash"
        ];
      }
    ];

    configFile = {
      "kwinrc"."Desktops"."Number" = {
        value = 1;
        immutable = true;
      };
      "kwinrc"."Wayland"."InputMethod[$e]" = {
        value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
        immutable = true;
      };

    };
  };
}
