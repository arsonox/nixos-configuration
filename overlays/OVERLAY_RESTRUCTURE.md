# Overlays Directory Restructuring - Summary

## What Changed

The overlays directory has been restructured to use a centralized `default.nix` file that automatically imports all overlays in the directory.

## Before

```nix
# configuration.nix
imports = [
  ./boot.nix
  ./overlays/znver5.nix
  ./overlays/plasma-wallpaper-application.nix
  ./overlays/plasma-smart-video-wallpaper-reborn.nix
]
```

Each overlay had to be manually imported in `configuration.nix`.

## After

```nix
# configuration.nix
imports = [
  ./boot.nix
  ./overlays
]
```

A single import of the `overlays` directory (which loads `default.nix`).

## Structure

```
overlays/
├── default.nix                              # Central import point
├── README.md                                # Documentation
├── OVERLAY_RESTRUCTURE.md                   # This file
├── znver5.nix                               # AMD Zen 5 optimizations
├── plasma-wallpaper-application.nix         # Application wallpaper plugin
└── plasma-smart-video-wallpaper-reborn.nix  # Video wallpaper plugin
```

## Benefits

1. **Cleaner configuration.nix**: Only one import line for all overlays
2. **Easier to add overlays**: Just create the file and add to `default.nix`
3. **Better organization**: All overlays in one place
4. **Self-documenting**: Clear structure and comprehensive README
5. **Scalability**: Easy to add more overlays without cluttering configuration.nix

## How It Works

### default.nix

```nix
{ ... }:

{
  imports = [
    ./znver5.nix
    ./plasma-wallpaper-application.nix
    ./plasma-smart-video-wallpaper-reborn.nix
  ];
}
```

This file is automatically loaded when you import `./overlays` in configuration.nix, thanks to Nix's module system.

### Individual Overlay Files

Each overlay file follows the standard pattern:

```nix
{ ... }:  # Simple overlays only need this

{
  nixpkgs.overlays = [
    (final: prev: {
      package-name = final.callPackage ../packages/package-name.nix { };
    })
  ];
}
```

For conditional overlays (like znver5.nix), additional parameters are used:

```nix
{ lib, config, ... }:  # When you need system config

{
  nixpkgs.overlays = lib.optionals (condition) [
    (final: prev: {
      # overlay content
    })
  ];
}
```

## Adding New Overlays

To add a new overlay:

1. **Create the overlay file** in `overlays/`:
   ```bash
   cd nixos/overlays
   touch my-new-overlay.nix
   ```

2. **Write the overlay**:
   ```nix
   { ... }:
   
   {
     nixpkgs.overlays = [
       (final: prev: {
         my-package = final.callPackage ../packages/my-package.nix { };
       })
     ];
   }
   ```

3. **Add to default.nix**:
   ```nix
   {
     imports = [
       ./znver5.nix
       ./plasma-wallpaper-application.nix
       ./plasma-smart-video-wallpaper-reborn.nix
       ./my-new-overlay.nix  # Add here
     ];
   }
   ```

4. **Rebuild**:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

That's it! No need to modify `configuration.nix`.

## Migration Notes

### What Was Changed

1. **Created** `overlays/default.nix` to import all overlays
2. **Updated** `configuration.nix` to use single overlay import
3. **Added** `overlays/README.md` for documentation
4. **Standardized** overlay file parameters (removed unused `config`, `lib` from simple overlays)

### What Stayed the Same

- All existing overlays continue to work identically
- No changes to overlay functionality
- Package definitions remain in `packages/` directory
- System configuration remains in `system-packages/` directory

### Compatibility

This change is fully backward compatible. The overlays work exactly the same way, just organized better.

## Testing

Verified that the restructuring works correctly:

```bash
# Check flake evaluates correctly
nix flake check --no-build

# Verify system can be built (dry-run)
sudo nixos-rebuild dry-build --flake .#<hostname>

# Test individual packages still build
nix build --impure --expr 'with import <nixpkgs> {}; kdePackages.callPackage ./packages/plasma-wallpaper-application.nix {}'
```

All tests pass successfully.

## Documentation

Comprehensive documentation added:

- **overlays/README.md**: Complete guide to overlays directory
  - Structure explanation
  - Available overlays
  - How to add new overlays
  - Overlay function reference
  - Testing and troubleshooting
  - Best practices

- **This file**: Migration and restructuring summary

## Current Overlays

### 1. znver5.nix
- **Purpose**: Compile optimizations for AMD Zen 5 CPUs
- **Applies to**: fwdesktop host only
- **Packages**: firefox-unwrapped (with more available commented out)
- **Conditional**: Yes (based on hostname)

### 2. plasma-wallpaper-application.nix
- **Purpose**: Add application wallpaper plugin to nixpkgs
- **Package**: plasma-wallpaper-application
- **Source**: ../packages/plasma-wallpaper-application.nix
- **Conditional**: No (always applied)

### 3. plasma-smart-video-wallpaper-reborn.nix
- **Purpose**: Add video wallpaper plugin to nixpkgs
- **Package**: plasma-smart-video-wallpaper-reborn
- **Source**: ../packages/plasma-smart-video-wallpaper-reborn.nix
- **Conditional**: No (always applied)

## Future Enhancements

Potential improvements for this structure:

1. **Auto-discovery**: Could potentially auto-discover overlay files (though explicit is often better)
2. **Namespacing**: Group related overlays in subdirectories
3. **Testing framework**: Add automated tests for overlays
4. **Documentation generation**: Auto-generate overlay list from files

For now, the explicit import list in `default.nix` provides the best balance of clarity and maintainability.

## Rollback

If you need to rollback to the old structure:

1. Remove `overlays/default.nix`
2. Update `configuration.nix` to import overlays individually:
   ```nix
   imports = [
     ./boot.nix
     ./overlays/znver5.nix
     ./overlays/plasma-wallpaper-application.nix
     ./overlays/plasma-smart-video-wallpaper-reborn.nix
   ]
   ```
3. Rebuild system

However, the new structure is recommended as it's cleaner and more maintainable.

## Summary

✓ Overlays directory restructured with centralized `default.nix`
✓ Configuration.nix simplified to single overlay import
✓ Comprehensive documentation added
✓ All existing functionality preserved
✓ Easy to add new overlays in the future
✓ All tests passing

The restructuring is complete and ready to use!