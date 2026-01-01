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

## plasma-smart-video-wallpaper-reborn

A KDE Plasma 6 wallpaper plugin to play videos on your Desktop or Lock Screen with advanced features.

### Description

This plugin allows you to use videos as your desktop or lock screen wallpaper with extensive control over playback, effects, and conditional behavior based on window state, battery level, and desktop effects.

### Features

- **Video Playback**:
  - Play single videos or slideshows
  - Enable/disable video sound with volume control
  - Playback speed control
  - Custom and random playback order
  - Cross-fade transitions between videos (Beta)

- **Pause Conditions**:
  - Maximized or fullscreen window
  - Active window
  - Window is present
  - Never pause
  - Based on active Desktop Effect (e.g., overview, show desktop)
  - Screen is Off/Locked

- **Blur Effects**:
  - Configurable blur radius and animation duration
  - Conditional blur based on:
    - Maximized or fullscreen window
    - Active window
    - Window is present
    - Video is paused
    - Always/Never
    - Based on active Desktop Effect

- **Battery Mode**:
  - Automatic pausing on low battery (configurable threshold)
  - Automatic blur disabling on battery mode

- **Lock Screen Support**: Works on both desktop and lock screen

### Installation

This package is automatically built and included in the system when you have:

1. The overlay enabled in `configuration.nix`:
   ```nix
   imports = [
     ./overlays/plasma-smart-video-wallpaper-reborn.nix
   ];
   ```

2. The package added to your KDE system packages in `system-packages/kde.nix`:
   ```nix
   environment.systemPackages = [ pkgs.plasma-smart-video-wallpaper-reborn ];
   ```

### Usage

After rebuilding your NixOS configuration:

**For Desktop Wallpaper**:
1. Right-click on your desktop
2. Select "Configure Desktop and Wallpaper..."
3. In the "Wallpaper type" dropdown, select "Smart Video Wallpaper Reborn"
4. Add your videos and configure settings
5. Apply the settings

**For Lock Screen Wallpaper**:
1. Go to System Settings → Screen Locking → Appearance: Configure...
2. Change "Wallpaper type" to "Smart Video Wallpaper Reborn"
3. Add your videos and configure settings
4. Apply

### Media Codec Requirements

This plugin requires properly configured media codecs for video playback:

- **Qt Multimedia**: `qt6-multimedia` (included in dependencies)
- **Media Backend**: Either `qt6-multimedia-ffmpeg` or `qt6-multimedia-gstreamer`
- **Codecs**: Additional codecs may be needed depending on your video formats

For NixOS, the necessary Qt multimedia packages are included, but you may need to enable additional codec support for certain video formats.

### Hardware Video Acceleration

For better performance and lower power consumption, enable hardware video acceleration. This allows your GPU to decode video instead of the CPU.

To verify acceleration is working, you can use:
- `nvtop` - Shows decoding usage for all GPUs
- `intel_gpu_top` - For Intel GPUs (video engine)
- `nvidia-smi dmon` - For Nvidia GPUs (dec column)
- `amdgpu_top` - For AMD GPUs (dec column)

### Switching Qt Media Backend

If you experience crashes or black screens (known issues with some AMD GPUs), try switching to GStreamer:

Add to your NixOS configuration:
```nix
environment.sessionVariables = {
  QT_MEDIA_BACKEND = "gstreamer";
};
```

You may also need to install GStreamer plugins:
```nix
environment.systemPackages = with pkgs; [
  gst_all_1.gstreamer
  gst_all_1.gst-plugins-base
  gst_all_1.gst-plugins-good
  gst_all_1.gst-plugins-bad
  gst_all_1.gst-plugins-ugly
  gst_all_1.gst-libav
];
```

### Source

- **Upstream repository**: https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn
- **KDE Store**: https://store.kde.org/p/2139746
- **License**: GNU GPL v2
- **Author**: Luis Bocanegra

### Dependencies

- KDE Plasma 6
- libplasma
- kpackage
- Qt6 Multimedia
- Qt6 Declarative

### Building

The package is built using the `mkKdeDerivation` helper from nixpkgs. The build process:

1. Fetches the source from GitHub (uses tagged releases)
2. Configures the build with CMake
3. Installs the wallpaper plugin using kpackagetool6

### Troubleshooting

**Plugin doesn't appear in wallpaper types**:
- Restart plasmashell: `systemctl --user restart plasma-plasmashell.service`
- Log out and back in

**Videos don't play or black screen**:
- Check that video codecs are installed
- Try switching Qt Media backend to GStreamer (see above)
- Check journalctl for errors: `journalctl --user -xeu plasma-plasmashell`
- Verify video works in another player first

**Crashes or segmentation faults**:
- Known issue with some AMD GPUs and Qt FFmpeg backend
- Switch to GStreamer backend (see above)
- Check if issue persists with different video files

**To recover from a crash loop**, remove videos from configuration:
```bash
sed -i 's/^VideoUrls=.*$/VideoUrls=/g' $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc $HOME/.config/kscreenlockerrc
```

### Updates

To update to the latest version:

1. Check for new releases: https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn/releases

2. Get the new hash:
   ```bash
   nix-shell -p nix-prefetch-github --run \
     "nix-prefetch-github --rev v<version> luisbocanegra plasma-smart-video-wallpaper-reborn"
   ```

3. Update `version`, `rev`, and `hash` fields in `nixos/packages/plasma-smart-video-wallpaper-reborn.nix`

4. Rebuild your system configuration