# KDE Plasma Wallpaper Plugins - Installation Summary

This document summarizes the two KDE Plasma 6 wallpaper plugins that have been added to your NixOS system.

## Overview

Two advanced wallpaper plugins have been successfully integrated into your NixOS configuration:

1. **plasma-wallpaper-application** - Run any application as your wallpaper
2. **plasma-smart-video-wallpaper-reborn** - Play videos as your wallpaper with smart features

Both plugins are automatically built and installed when you rebuild your system.

---

## 1. Plasma Wallpaper Application

### What It Does
Allows you to run ANY application as your desktop wallpaper or screensaver. Works with Wayland apps directly and X11 apps through Xwayland.

### Version
- **Current**: unstable-2025-10-28
- **License**: GPL-3.0-or-later
- **Source**: https://invent.kde.org/dos/plasma-wallpaper-application

### Example Use Cases

```bash
# Weather widget
kweather

# Classic XScreensaver
xwayland-run -- /usr/lib/xscreensaver/flyingtoasters --root

# Windows screensaver via Wine
xwayland-run -- wine ~/3D\ Pipes.scr /s

# Terminal with system monitor
konsole --separate --builtin-profile -e htop

# Aquarium animation
konsole --separate --builtin-profile -e asciiquarium

# Any Godot game/application
godot --fullscreen your_app.pck
```

### Quick Setup
1. Right-click desktop → "Configure Desktop and Wallpaper..."
2. Wallpaper type → "Application"
3. Enter your command
4. Apply

### Performance Tip
For GPU-accelerated applications, set:
```bash
export QT_WAYLAND_HARDWARE_INTEGRATION=linux-dmabuf-unstable-v1
```

Or in NixOS config:
```nix
environment.sessionVariables = {
  QT_WAYLAND_HARDWARE_INTEGRATION = "linux-dmabuf-unstable-v1";
};
```

---

## 2. Plasma Smart Video Wallpaper Reborn

### What It Does
Play videos as your desktop or lock screen wallpaper with advanced control over playback, pausing, blur effects, and battery optimization.

### Version
- **Current**: 2.8.1 (latest release)
- **License**: GPL-2.0
- **Source**: https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn

### Key Features

#### Playback Control
- Single video or slideshow mode
- Volume control and mute
- Playback speed adjustment
- Random or custom order
- Cross-fade transitions (Beta)

#### Smart Pause Conditions
Automatically pause video when:
- Window is maximized/fullscreen
- Specific window is active
- Any window matches criteria
- Desktop effects active (Overview, Show Desktop, etc.)
- Screen is off or locked
- Battery below threshold

#### Blur Effects
- Configurable blur radius and animation
- Conditional blur activation:
  - When windows are maximized
  - When specific windows active
  - When video is paused
  - Based on desktop effects
  - Always/Never

#### Battery Optimization
- Set battery threshold for auto-pause
- Auto-disable blur on battery mode
- Conserve power on laptops

### Quick Setup

**Desktop Wallpaper:**
1. Right-click desktop → "Configure Desktop and Wallpaper..."
2. Wallpaper type → "Smart Video Wallpaper Reborn"
3. Add videos with "+"
4. Configure playback, pause conditions, blur
5. Apply

**Lock Screen:**
1. System Settings → Screen Locking → Appearance: Configure...
2. Wallpaper type → "Smart Video Wallpaper Reborn"
3. Add and configure videos
4. Apply

### Performance Optimization

**Enable Hardware Acceleration:**
Monitor with `nvtop`, `intel_gpu_top`, `nvidia-smi dmon`, or `amdgpu_top`

**If experiencing crashes (AMD GPU issue):**
Switch to GStreamer backend:
```nix
environment.sessionVariables = {
  QT_MEDIA_BACKEND = "gstreamer";
};

environment.systemPackages = with pkgs; [
  gst_all_1.gstreamer
  gst_all_1.gst-plugins-base
  gst_all_1.gst-plugins-good
  gst_all_1.gst-plugins-bad
  gst_all_1.gst-plugins-ugly
  gst_all_1.gst-libav
];
```

---

## Installation Instructions

### Prerequisites
Both plugins are already configured in your system. You just need to rebuild.

### Building and Installing

```bash
# For your current machine
sudo nixos-rebuild switch --flake .#<hostname>

# Replace <hostname> with: nixos, fwdesktop, or lappytop
```

### After Installation

```bash
# Restart Plasma Shell (if needed)
systemctl --user restart plasma-plasmashell.service

# Or log out and back in
```

---

## Files Added to Your Configuration

### Package Definitions
- `nixos/packages/plasma-wallpaper-application.nix`
- `nixos/packages/plasma-smart-video-wallpaper-reborn.nix`

### Overlays
- `nixos/overlays/plasma-wallpaper-application.nix`
- `nixos/overlays/plasma-smart-video-wallpaper-reborn.nix`

### Documentation
- `nixos/packages/README.md` (updated)
- `nixos/packages/PLASMA_WALLPAPER_APPLICATION.md`
- `nixos/packages/PLASMA_SMART_VIDEO_WALLPAPER.md`
- `nixos/packages/WALLPAPER_PLUGINS_SUMMARY.md` (this file)

### Configuration Changes
- `nixos/configuration.nix` - Added overlay imports
- `nixos/system-packages/kde.nix` - Added packages to system

---

## Troubleshooting

### Plugins Don't Appear in Wallpaper Types

```bash
# Restart plasmashell
systemctl --user restart plasma-plasmashell.service

# Or log out and back in
```

### Application Wallpaper Issues

**App doesn't display:**
- Test app standalone first
- Some apps need specific flags for fullscreen
- X11 apps need `xwayland-run --` wrapper
- Check logs: `journalctl --user -xeu plasma-plasmashell`

**Black screen:**
- Application might not be Wayland-compatible
- Try with xwayland-run
- Check if app requires specific environment variables

### Video Wallpaper Issues

**Videos don't play:**
- Verify video plays in VLC or mpv
- Try switching to GStreamer backend (see above)
- Check codec support
- Convert to MP4 H.264 if needed:
  ```bash
  ffmpeg -i input.mkv -c:v libx264 -c:a aac output.mp4
  ```

**Plasma crashes:**
Emergency recovery:
```bash
# Remove video configuration
sed -i 's/^VideoUrls=.*$/VideoUrls=/g' \
  $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc \
  $HOME/.config/kscreenlockerrc

# Restart
systemctl --user restart plasma-plasmashell.service
```

**High CPU/battery usage:**
- Enable hardware video acceleration
- Configure battery mode in plugin settings
- Use lower resolution videos
- Enable pause conditions (e.g., pause when fullscreen)

---

## Updating Packages

### plasma-wallpaper-application

```bash
# Get latest commit
git ls-remote https://invent.kde.org/dos/plasma-wallpaper-application.git HEAD

# Get hash
nix-shell -p nix-prefetch-git --run \
  "nix-prefetch-git --url https://invent.kde.org/dos/plasma-wallpaper-application.git --rev <commit>"

# Update nixos/packages/plasma-wallpaper-application.nix
# Update rev, hash, and version fields
```

### plasma-smart-video-wallpaper-reborn

```bash
# Check latest release
curl -s https://api.github.com/repos/luisbocanegra/plasma-smart-video-wallpaper-reborn/releases/latest | grep tag_name

# Get hash
nix-shell -p nix-prefetch-github --run \
  "nix-prefetch-github --rev v<version> luisbocanegra plasma-smart-video-wallpaper-reborn"

# Update nixos/packages/plasma-smart-video-wallpaper-reborn.nix
# Update version, rev, and hash fields
```

After updating, rebuild your system.

---

## Tips and Best Practices

### For Application Wallpaper

1. **Test applications first** - Make sure they run standalone
2. **Use fullscreen mode** - Most apps need explicit fullscreen flags
3. **Consider resource usage** - Some apps can be CPU/GPU intensive
4. **Wayland preferred** - Better performance than X11 through Xwayland
5. **Check compatibility** - Not all apps work well as wallpapers

### For Video Wallpaper

1. **Optimize videos** - Match screen resolution, use H.264 codec
2. **Enable hardware acceleration** - Critical for performance
3. **Use pause conditions** - Save resources when not needed
4. **Configure battery mode** - Essential for laptops
5. **Test with short clips first** - Before using large video files
6. **Consider file size** - Lower bitrate for wallpapers is fine

### Video Recommendations
- **Resolution**: Match your screen or 1080p
- **Codec**: H.264 for best compatibility
- **Bitrate**: 5-10 Mbps
- **Framerate**: 30 fps sufficient
- **Duration**: Shorter loops (15-60s) work well

### Free Video Sources
- Pexels Videos: https://www.pexels.com/videos/
- Pixabay Videos: https://pixabay.com/videos/
- Videezy: https://www.videezy.com/

---

## Next Steps

1. **Commit changes** to your git repository:
   ```bash
   git status
   git commit -m "Add KDE Plasma wallpaper plugins"
   ```

2. **Rebuild your system**:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

3. **Configure your wallpapers**:
   - Try the Application wallpaper with simple commands
   - Add some videos to the Video wallpaper plugin
   - Experiment with pause conditions and blur effects

4. **Optimize for your use case**:
   - Set up battery-saving features for laptops
   - Configure pause conditions based on your workflow
   - Enable hardware acceleration for better performance

---

## Support and Resources

### plasma-wallpaper-application
- Repository: https://invent.kde.org/dos/plasma-wallpaper-application
- KDE Store: https://store.kde.org/p/2318884/
- Author: Sebastian Krzyszkowiak (dos@dosowisko.net)

### plasma-smart-video-wallpaper-reborn
- Repository: https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn
- KDE Store: https://store.kde.org/p/2139746
- Issues: https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn/issues
- Sponsor: https://github.com/sponsors/luisbocanegra

### General KDE Resources
- KDE Community: https://kde.org/community/
- KDE Store: https://store.kde.org/
- Plasma Wallpapers Documentation: https://develop.kde.org/docs/plasma/wallpapers/

---

## Contributing

If you find issues or have improvements:

1. Test with the latest version first
2. Check existing issues on the respective repositories
3. Provide detailed information:
   - NixOS version
   - Plasma version
   - Hardware details (GPU)
   - Steps to reproduce
   - Relevant logs

For NixOS packaging issues with these plugins, consider submitting to nixpkgs if they prove stable.

---

## Enjoy Your Dynamic Wallpapers! 🎨🎬

You now have two powerful wallpaper plugins at your disposal. Experiment with different applications and videos to create the perfect desktop experience!