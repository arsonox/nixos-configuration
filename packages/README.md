# Custom NixOS Packages

This directory contains custom package derivations that are not yet available in nixpkgs or require custom builds.

## plasma-wallpaper-application

A KDE Plasma 6 wallpaper plugin that allows you to set an arbitrary application as your desktop background or screensaver.

### Description

This plugin works by becoming a simple Wayland compositor that can accept a single fullscreen window from your chosen application. While it only supports Wayland clients directly, it can use Xwayland to support X11 applications as well.

### Examples

Here are some example applications you can run as your wallpaper:

- **Weather widget**: `kweather`
- **XScreensaver hacks**: `xwayland-run -- /usr/lib/xscreensaver/flyingtoasters --root`
- **Windows screensavers via Wine**: `xwayland-run -- wine ~/3D\ Pipes.scr /s`
- **Terminal applications**: `konsole --separate --builtin-profile -p ScrollBarPosition=2 -p ColorScheme=WhiteOnBlack -p ShowTerminalSizeHint=false -p CursorShape=3 -p HighlightScrolledLines=false -e "asciiquarium"`
- **System monitor**: `htop` in a terminal
- **Custom applications**: Anything written in Godot, SDL, or other frameworks

### Installation

This package is automatically built and included in the system when you have:

1. The overlay enabled in `configuration.nix`:
   ```nix
   imports = [
     ./overlays/plasma-wallpaper-application.nix
   ];
   ```

2. The package added to your KDE system packages in `system-packages/kde.nix`:
   ```nix
   environment.systemPackages = [ pkgs.plasma-wallpaper-application ];
   ```

### Usage

After rebuilding your NixOS configuration:

1. Right-click on your desktop
2. Select "Configure Desktop and Wallpaper..."
3. In the "Wallpaper type" dropdown, select "Application"
4. Enter the command for the application you want to run
5. Apply the settings

### Performance Optimization

By default, QtWayland only exposes the shared memory interface (wl_shm) for buffer sharing, which can be inefficient for high-resolution GPU-rendered clients. For better performance with GPU-accelerated applications, set the following environment variable:

```bash
export QT_WAYLAND_HARDWARE_INTEGRATION=linux-dmabuf-unstable-v1
```

You can add this to your shell profile or set it in your NixOS configuration.

### Source

- **Upstream repository**: https://invent.kde.org/dos/plasma-wallpaper-application
- **License**: GNU GPL v3 or later
- **Author**: Sebastian Krzyszkowiak <dos@dosowisko.net>

### Dependencies

- QtWayland (for Wayland compositor functionality)
- KDE Plasma 6
- libplasma
- kpackage

### Building

The package is built using the `mkKdeDerivation` helper from nixpkgs, which handles the KDE-specific build configuration automatically. The build process:

1. Fetches the source from KDE's GitLab instance
2. Configures the build with CMake
3. Installs the wallpaper plugin using kpackagetool6

### Troubleshooting

If the wallpaper plugin doesn't appear in the wallpaper type dropdown:

1. Restart plasmashell: `systemctl --user restart plasma-plasmashell.service`
2. Check that the package is installed: `nix-store -q --references /run/current-system | grep plasma-wallpaper`
3. Verify the plugin is in the correct location: `ls ~/.local/share/plasma/wallpapers/` or system-wide location

### Updates

To update to the latest version:

1. Get the latest commit hash from the upstream repository
2. Update the `rev` field in `plasma-wallpaper-application.nix`
3. Update the hash by running:
   ```bash
   nix-shell -p nix-prefetch-git --run "nix-prefetch-git --url https://invent.kde.org/dos/plasma-wallpaper-application.git --rev <new-commit-hash>"
   ```
4. Update both the `rev` and `hash` fields in the package definition
5. Rebuild your system configuration