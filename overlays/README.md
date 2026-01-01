# NixOS Overlays

This directory contains NixOS overlays that modify or add packages to nixpkgs.

## Structure

All overlays in this directory are automatically imported via `default.nix`, which is included in the main `configuration.nix`.

## Available Overlays

### znver5.nix
Compiler optimization overlay for AMD Zen 5 architecture.

**Applies to hosts:** `fwdesktop`

**What it does:**
- Applies `-O3 -march=znver5 -mtune=znver5` optimization flags
- Currently optimizes: `firefox-unwrapped`
- Commented out optimizations available for: ffmpeg, libvpx, x264, x265, zstd, openssl, mesa, jemalloc

**Usage:**
The overlay automatically applies to the specified hosts. To enable optimizations for additional packages, uncomment the relevant lines in the file.

**Note:** This overlay conditionally applies based on hostname, so it uses `lib` and `config` parameters.

### plasma-wallpaper-application.nix
Adds the `plasma-wallpaper-application` package to nixpkgs.

**What it does:**
- Makes `pkgs.plasma-wallpaper-application` available system-wide
- Allows running arbitrary applications as Plasma wallpapers/screensavers

**Package location:** `../packages/plasma-wallpaper-application.nix`

**Features:**
- Run any Wayland/X11 application as wallpaper
- Supports xscreensavers, Wine apps, terminals, custom applications
- Works on Plasma 6

### plasma-smart-video-wallpaper-reborn.nix
Adds the `plasma-smart-video-wallpaper-reborn` package to nixpkgs.

**What it does:**
- Makes `pkgs.plasma-smart-video-wallpaper-reborn` available system-wide
- Play videos as desktop/lock screen wallpaper with advanced features

**Package location:** `../packages/plasma-smart-video-wallpaper-reborn.nix`

**Features:**
- Video playback with volume/speed control
- Smart pause conditions (window state, battery, desktop effects)
- Blur effects with configurable conditions
- Lock screen support
- Battery optimization

## Adding New Overlays

To add a new overlay:

1. Create a new `.nix` file in this directory:
   ```nix
   { ... }:
   
   {
     nixpkgs.overlays = [
       (final: prev: {
         your-package-name = final.callPackage ../packages/your-package.nix { };
       })
     ];
   }
   ```

2. Add it to `default.nix`:
   ```nix
   {
     imports = [
       ./znver5.nix
       ./plasma-wallpaper-application.nix
       ./plasma-smart-video-wallpaper-reborn.nix
       ./your-new-overlay.nix  # Add this line
     ];
   }
   ```

3. Rebuild your system:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Overlay Parameters

### Simple Overlays
Most overlays only need `{ ... }:` as parameters:
```nix
{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # your overlay
    })
  ];
}
```

### Conditional Overlays
If you need to conditionally apply overlays based on system configuration, include the necessary parameters:
```nix
{ lib, config, ... }:

{
  nixpkgs.overlays = lib.optionals (condition) [
    (final: prev: {
      # your overlay
    })
  ];
}
```

## Overlay Functions

Inside the overlay function:
- `final`: The final package set (after all overlays applied)
- `prev`: The previous package set (before this overlay)
- `self`: Alias for `final` (deprecated, use `final` instead)
- `super`: Alias for `prev` (deprecated, use `prev` instead)

### Examples

**Override an existing package:**
```nix
nixpkgs.overlays = [
  (final: prev: {
    firefox = prev.firefox.override {
      # your overrides
    };
  })
];
```

**Add a new package:**
```nix
nixpkgs.overlays = [
  (final: prev: {
    my-package = final.callPackage ../packages/my-package.nix { };
  })
];
```

**Modify package attributes:**
```nix
nixpkgs.overlays = [
  (final: prev: {
    firefox-unwrapped = prev.firefox-unwrapped.overrideAttrs (old: {
      env = (old.env or { }) // {
        NIX_CFLAGS_COMPILE = "${old.env.NIX_CFLAGS_COMPILE or ""} -O3";
      };
    });
  })
];
```

## Testing Overlays

Test if your overlay works:

```bash
# Check if package is available (in NixOS context)
nix eval .#nixosConfigurations.<hostname>.config.environment.systemPackages --json | grep your-package

# Try to build the package
nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./packages/your-package.nix {}'

# Check the flake
nix flake check --no-build
```

## Troubleshooting

**Overlay not applying:**
- Ensure the overlay file is added to `default.nix`
- Check that `default.nix` is imported in `configuration.nix`
- Rebuild your system
- Check for evaluation errors: `nix flake check`

**Package not found:**
- Verify the package path in `callPackage` is correct
- Ensure the package file exists and is added to git (for flakes)
- Check that the package builds: `nix build .#packages.<package-name>`

**Conditional overlay not working:**
- Verify the condition logic
- Check that required parameters (`lib`, `config`) are included
- Test the condition: `nix eval .#nixosConfigurations.<hostname>.config.networking.hostName`

## Best Practices

1. **Keep overlays focused**: One overlay per package or logical grouping
2. **Use `callPackage`**: Let Nix handle dependency injection
3. **Document conditions**: If overlay is conditional, document when it applies
4. **Test before committing**: Ensure the overlay doesn't break the build
5. **Use `final` and `prev`**: Modern naming, not `self` and `super`
6. **Minimal parameters**: Only include parameters you actually use

## See Also

- [Nixpkgs Overlays Manual](https://nixos.org/manual/nixpkgs/stable/#chap-overlays)
- [NixOS Wiki - Overlays](https://nixos.wiki/wiki/Overlays)
- Package definitions: `../packages/`
- System packages: `../system-packages/`
