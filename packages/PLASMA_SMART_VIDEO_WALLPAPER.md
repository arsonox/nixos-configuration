# Plasma Smart Video Wallpaper Reborn - Installation Summary

## What Was Done

Added the KDE Plasma 6 wallpaper plugin `plasma-smart-video-wallpaper-reborn` to your NixOS system. This plugin allows you to play videos as your desktop or lock screen wallpaper with advanced control features.

## Files Created/Modified

### New Files
1. **nixos/packages/plasma-smart-video-wallpaper-reborn.nix** - Package derivation
2. **nixos/overlays/plasma-smart-video-wallpaper-reborn.nix** - Overlay to make package available
3. **nixos/packages/PLASMA_SMART_VIDEO_WALLPAPER.md** - This file

### Modified Files
1. **nixos/configuration.nix** - Added overlay import
2. **nixos/system-packages/kde.nix** - Added package to system packages
3. **nixos/packages/README.md** - Added documentation section

## Package Information

- **Version**: 2.8.1 (latest release)
- **License**: GPL-2.0
- **Repository**: https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn
- **KDE Store**: https://store.kde.org/p/2139746

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

### Setting Up Desktop Wallpaper

1. Right-click on desktop → "Configure Desktop and Wallpaper..."
2. Change "Wallpaper type" dropdown to "Smart Video Wallpaper Reborn"
3. Click "+" to add videos
4. Configure settings:
   - **General**: Playback order, speed, volume
   - **Pause Video**: Set conditions for when to pause
   - **Blur**: Configure blur effects and conditions
   - **Advanced**: Battery mode, cross-fade transitions
5. Click Apply

### Setting Up Lock Screen Wallpaper

1. System Settings → Screen Locking → Appearance: Configure...
2. Change "Wallpaper type" to "Smart Video Wallpaper Reborn"
3. Add and configure videos
4. Apply

## Key Features

### Playback Control
- Play single videos or create slideshows
- Adjustable playback speed
- Volume control (including mute)
- Custom or random playback order
- Cross-fade transitions between videos (Beta feature)

### Smart Pause Conditions
The video can automatically pause based on:
- **Window State**: Maximized or fullscreen window present
- **Active Window**: Specific window is active
- **Window Present**: Any window with specific criteria
- **Desktop Effects**: Overview, show desktop, etc.
- **Screen State**: When screen is off or locked
- **Never**: Continuous playback

### Blur Effects
Configure background blur with:
- Adjustable blur radius
- Configurable animation duration
- Conditional blur activation:
  - When windows are maximized/fullscreen
  - When specific windows are active
  - When video is paused
  - Based on desktop effects
  - Always or never

### Battery Optimization
- Set battery threshold for automatic video pause
- Automatic blur disabling in battery mode
- Helps conserve power on laptops

## Video Format Support

The plugin uses Qt6 Multimedia for video playback. Supported formats depend on your media backend:

### FFmpeg Backend (default)
Most common formats are supported including:
- MP4 (H.264, H.265)
- WebM (VP8, VP9)
- AVI
- MKV
- MOV

### GStreamer Backend (alternative)
Similar format support with potentially better compatibility for some systems.

## Performance Optimization

### Hardware Video Acceleration

For best performance, enable hardware video acceleration. This offloads video decoding to your GPU:

**Check if acceleration is working:**
```bash
# Install monitoring tool
nix-shell -p nvtop

# Run and check for decoding usage
nvtop
```

Alternative tools:
- Intel: `intel_gpu_top` (from intel-gpu-tools)
- Nvidia: `nvidia-smi dmon` (check 'dec' column)
- AMD: `amdgpu_top` (check 'dec' column)

### Switching to GStreamer Backend

If you experience crashes or black screens (known issue with some AMD GPUs), switch to GStreamer:

**Add to your NixOS configuration:**
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

Rebuild and reboot for changes to take effect.

## Troubleshooting

### Plugin Doesn't Appear

**Solution:**
```bash
# Restart plasmashell
systemctl --user restart plasma-plasmashell.service

# Or log out and back in
```

### Video Doesn't Play / Black Screen

**Possible causes and solutions:**

1. **Missing codecs**:
   - Verify video plays in another application (like VLC)
   - Try switching to GStreamer backend (see above)

2. **Wrong format**:
   - Convert video to MP4 with H.264:
     ```bash
     ffmpeg -i input.mkv -c:v libx264 -c:a aac output.mp4
     ```

3. **Hardware issues**:
   - Check journalctl: `journalctl --user -xeu plasma-plasmashell`
   - Try disabling hardware acceleration temporarily

### Plasma Crashes

**Emergency recovery:**

If plasmashell crashes in a loop after setting videos:

```bash
# Remove video configuration
sed -i 's/^VideoUrls=.*$/VideoUrls=/g' \
  $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc \
  $HOME/.config/kscreenlockerrc

# Restart plasmashell
systemctl --user restart plasma-plasmashell.service
```

**Known issue**: AMD GPUs with Qt FFmpeg backend may crash. Use GStreamer backend.

### High CPU/Battery Usage

**Solutions:**

1. **Enable hardware acceleration** (see Performance Optimization above)

2. **Configure battery mode**:
   - In plugin settings → Advanced
   - Set battery threshold (e.g., 50%)
   - Video will pause when battery drops below threshold

3. **Reduce video quality/resolution**:
   - Lower resolution videos use less resources
   - Consider 720p instead of 4K for wallpapers

4. **Use pause conditions**:
   - Pause when fullscreen window present
   - Pause when screen is locked

## Advanced Configuration

### Multiple Monitors

The plugin works with multiple monitors. Configure separately for each desktop if needed.

### Custom Pause Conditions

Combine multiple pause conditions:
- Pause when window "Firefox" is present AND fullscreen
- Pause during "Overview" effect AND when battery < 30%

### Blur Configuration

Experiment with blur settings:
- **Low blur** (5-10): Subtle effect, better performance
- **Medium blur** (15-20): Balanced
- **High blur** (25-30): Strong effect, higher GPU usage

### Cross-Fade Transitions

Enable in Advanced settings:
- Smooth transitions between videos in slideshow
- Configurable duration
- Beta feature - may have performance impact

## Updating the Package

To update to a newer version:

1. **Check for new releases**:
   ```bash
   curl -s https://api.github.com/repos/luisbocanegra/plasma-smart-video-wallpaper-reborn/releases/latest | grep tag_name
   ```

2. **Get the new hash**:
   ```bash
   nix-shell -p nix-prefetch-github --run \
     "nix-prefetch-github --rev v<new-version> luisbocanegra plasma-smart-video-wallpaper-reborn"
   ```

3. **Update the package**:
   - Edit `nixos/packages/plasma-smart-video-wallpaper-reborn.nix`
   - Update `version`, `rev`, and `hash` fields

4. **Rebuild**:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Tips and Tricks

### Best Video Settings for Wallpapers

- **Resolution**: Match your screen resolution or slightly lower
- **Codec**: H.264 for best compatibility
- **Bitrate**: 5-10 Mbps for good quality without huge files
- **Framerate**: 30 fps is sufficient for wallpapers

### Creating Video Loops

For seamless loops:
```bash
ffmpeg -i input.mp4 -filter_complex "[0:v]reverse,fifo[r];[0:v][r] concat=n=2:v=1 [v]" \
  -map "[v]" seamless_loop.mp4
```

### Finding Free Video Wallpapers

- **Pexels Videos**: https://www.pexels.com/videos/
- **Pixabay Videos**: https://pixabay.com/videos/
- **Videezy**: https://www.videezy.com/

Many offer free, high-quality videos suitable for wallpapers.

## Support the Developer

If you enjoy this plugin, consider supporting the developer:
- GitHub Sponsors: https://github.com/sponsors/luisbocanegra
- Ko-fi: https://ko-fi.com/luisbocanegra
- Liberapay: https://liberapay.com/luisbocanegra

## Next Steps

You can now:
1. Commit these changes to your git repository
2. Rebuild your system to install the plugin
3. Configure your video wallpapers!

Enjoy your dynamic video wallpapers with smart pause and blur features! 🎬