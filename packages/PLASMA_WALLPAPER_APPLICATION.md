# Plasma Wallpaper Application - Installation Summary

## What Was Done

Added the KDE Plasma 6 wallpaper plugin `plasma-wallpaper-application` to your NixOS system. This plugin allows you to use any application as your desktop wallpaper or screensaver.

## Files Created/Modified

### New Files
1. **nixos/packages/plasma-wallpaper-application.nix** - Package derivation
2. **nixos/overlays/plasma-wallpaper-application.nix** - Overlay to make package available
3. **nixos/packages/README.md** - Documentation for custom packages
4. **nixos/packages/PLASMA_WALLPAPER_APPLICATION.md** - This file

### Modified Files
1. **nixos/configuration.nix** - Added overlay import
2. **nixos/system-packages/kde.nix** - Added package to system packages

## How to Use

### Activating the Plugin

1. **Rebuild your system**:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```
   Replace `<hostname>` with your machine name (nixos, fwdesktop, or lappytop)

2. **Restart Plasma Shell** (if already running):
   ```bash
   systemctl --user restart plasma-plasmashell.service
   ```

3. **Configure your wallpaper**:
   - Right-click on desktop → "Configure Desktop and Wallpaper..."
   - Change "Wallpaper type" dropdown to "Application"
   - Enter your command in the application field
   - Click Apply

### Example Commands to Try

**Weather Widget**:
```
kweather
```

**Classic XScreensaver (Flying Toasters)**:
```
xwayland-run -- /usr/lib/xscreensaver/flyingtoasters --root
```

**Windows Screensaver via Wine**:
```
xwayland-run -- wine ~/3D\ Pipes.scr /s
```

**Terminal with Aquarium**:
```
konsole --separate --builtin-profile -p ScrollBarPosition=2 -p ColorScheme=WhiteOnBlack -p ShowTerminalSizeHint=false -p CursorShape=3 -p HighlightScrolledLines=false -e "asciiquarium"
```

**System Monitor**:
```
konsole --separate --builtin-profile -e htop
```

## Performance Tip

For better performance with GPU-accelerated applications, add this to your shell configuration or NixOS config:

```bash
export QT_WAYLAND_HARDWARE_INTEGRATION=linux-dmabuf-unstable-v1
```

To add it system-wide in NixOS, add to your configuration.nix:
```nix
environment.sessionVariables = {
  QT_WAYLAND_HARDWARE_INTEGRATION = "linux-dmabuf-unstable-v1";
};
```

## Updating the Package

To update to a newer version:

1. Get the latest commit:
   ```bash
   git ls-remote https://invent.kde.org/dos/plasma-wallpaper-application.git HEAD
   ```

2. Get the new hash:
   ```bash
   nix-shell -p nix-prefetch-git --run \
     "nix-prefetch-git --url https://invent.kde.org/dos/plasma-wallpaper-application.git --rev <commit-hash>"
   ```

3. Update `rev` and `hash` fields in `nixos/packages/plasma-wallpaper-application.nix`

4. Rebuild your system

## Troubleshooting

**Plugin doesn't appear in wallpaper types**:
- Restart plasmashell: `systemctl --user restart plasma-plasmashell.service`
- Log out and back in

**Application doesn't display**:
- Check the application works standalone first
- Some applications may need specific flags to run fullscreen
- Check journalctl for errors: `journalctl --user -xeu plasma-plasmashell`

**Black screen**:
- The application might not be Wayland-compatible
- Try wrapping X11 apps with `xwayland-run --`
- Some applications need additional setup

## Source Information

- **Repository**: https://invent.kde.org/dos/plasma-wallpaper-application
- **KDE Store**: https://store.kde.org/p/2318884/
- **Author**: Sebastian Krzyszkowiak (dos@dosowisko.net)
- **License**: GPL-3.0-or-later

## Next Steps

You can now:
1. Commit these changes to your git repository
2. Rebuild your system to install the plugin
3. Configure your wallpaper with any application you want!

Enjoy your dynamic wallpapers!