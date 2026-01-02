# Nox' NixOS Configuration

A modular, flake-based NixOS configuration with home-manager integration, supporting multiple hosts with shared and host-specific configurations.

## 📋 Table of Contents

- [Configuration Structure](#configuration-structure)
- [Hosts](#hosts)
- [Quick Start Installation](#quick-start-installation)
- [Usage](#usage)
- [Customization](#customization)
- [Maintenance](#maintenance)

## 📁 Configuration Structure

```
.
├── flake.nix                 # Main flake configuration defining inputs and outputs
├── flake.lock                # Lock file for reproducible builds
├── hosts/                    # Host-specific configurations
│   ├── shared/               # Shared configuration modules
│   │   ├── default.nix       # Base system configuration
│   │   ├── boot.nix          # Boot loader and initrd settings
│   │   ├── global/           # Global modules enabled on all hosts
│   │   ├── optional/         # Optional modules (currently empty)
│   │   └── users/            # User account definitions
│   ├── nixos/                # VM configuration
│   ├── fwdesktop/            # Framework desktop host
│   └── lappytop/             # Laptop host configuration
├── home/                     # Home Manager configurations
│   ├── nox.nix               # Main user configuration
│   └── apps/                 # Per-application home-manager configs
│       ├── kde.nix           # KDE Plasma settings
│       ├── zsh.nix           # Zsh shell configuration
│       ├── git.nix           # Git configuration
│       ├── vim.nix           # Vim configuration
│       ├── zed.nix           # Zed editor configuration
│       └── ...               # Other application configs
├── overlays/                 # Nixpkgs overlays for custom packages
│   ├── default.nix           # Main overlay loader
│   ├── znver5.nix            # AMD Zen 5 optimizations
│   └── ...                   # Custom package overlays
├── packages/                 # Custom package definitions
│   ├── plasma-smart-video-wallpaper-reborn.nix
│   └── plasma-wallpaper-application.nix
├── wallpapers/               # Wallpaper assets
└── assets/                   # Other assets
```

## 🖥️ Hosts

This configuration supports three hosts:

### fwdesktop
My primary desktop configuration.

### lappytop
My laptop configuration.

### nixos
The configuration for VM use.

## 🚀 Quick Start Installation

### Prerequisites
- NixOS live CD/USB
- Internet connection
- Basic familiarity with disk partitioning

### Installation Steps

1. **Boot into NixOS live environment**

2. **Partition your disks** using `cfdisk` or your preferred tool:
   - Create a `/boot` partition (512MB-1GB, FAT32)
   - Optionally add a swap partition
   - Partition remaining space as btrfs

3. **Format partitions:**
   ```sh
   mkfs.fat -F 32 /dev/sdX1  # Boot partition
   mkfs.btrfs /dev/sdX2       # Root partition
   ```

4. **Mount the root partition and create btrfs subvolumes:**
   ```sh
   mount /dev/sdX2 /mnt
   btrfs subvolume create /mnt/root
   btrfs subvolume create /mnt/home
   btrfs subvolume create /mnt/nix
   umount /mnt
   ```

5. **Remount with subvolumes:**
   ```sh
   mount -o subvol=root,compress=zstd,noatime /dev/sdX2 /mnt
   mkdir -p /mnt/{boot,home,nix}
   mount -o subvol=home,compress=zstd,noatime /dev/sdX2 /mnt/home
   mount -o subvol=nix,compress=zstd,noatime /dev/sdX2 /mnt/nix
   mount /dev/sdX1 /mnt/boot
   ```

6. **Generate hardware configuration:**
   ```sh
   nixos-generate-config --root /mnt
   ```
   Keep the generated `hardware-configuration.nix` file.

7. **Clone this repository:**
   ```sh
   git clone <repository-url> /mnt/etc/nixos
   ```

8. **Add hardware configuration to hosts:**
   ```sh
   cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/$HOSTNAME/$HOSTNAME-hw.nix
   ```
   Update the host's `default.nix` to import this hardware configuration.

9. **Install NixOS:**
   ```sh
   nixos-install --flake /mnt/etc/nixos#$HOSTNAME
   ```

10. **Set user password:**
    ```sh
    nixos-enter --root /mnt -c 'passwd nox'
    ```

11. **Reboot:**
    ```sh
    reboot
    ```

12. **Post-installation: Move config to home directory** (optional but recommended):
    ```sh
    mv /etc/nixos /home/nox/etc/nixos
    sudo ln -s /home/nox/etc/nixos /etc/nixos
    ```

### Optional: Create Btrfs Swapfile

If you prefer a swapfile over a swap partition:

```sh
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 16g /swap/swapfile
```

Then add to your hardware configuration:
```nix
swapDevices = [ { device = "/swap/swapfile"; } ];
```

## 💻 Usage

### Rebuilding the System

Using the built-in `nh` (nix-helper) tool:
```sh
nh os switch --ask
```

Or using traditional nixos-rebuild:
```sh
sudo nixos-rebuild switch --flake .#$HOSTNAME
```

### Updating the System

Update flake inputs and rebuild:
```sh
nix flake update
nh os switch
```

### Checking for Updates Without Installing

```sh
nh os build
```

### Checking the Configuration Alone

```sh
nix flake check --no-build
```

### Cleaning Old Generations

```sh
nh clean all --keep 3
```

Or manually:
```sh
sudo nix-collect-garbage -d
sudo nixos-rebuild boot
```

### Testing Changes Without Committing

Build and activate temporarily (resets on reboot):
```sh
sudo nixos-rebuild test --flake .#$HOSTNAME
```

## 🎨 Customization

### Adding a New Host

1. Create a new directory in `hosts/`:
   ```sh
   mkdir -p hosts/newhostname
   ```

2. Create `hosts/newhostname/default.nix`:
   ```nix
   { ... }:
   {
     imports = [
       ./newhostname-hw.nix
       ../shared
     ];
     
     networking.hostName = "newhostname";
     # Add host-specific configuration here
   }
   ```

3. Add hardware configuration to `hosts/newhostname/newhostname-hw.nix`

4. Register in `flake.nix`:
   ```nix
   nixosConfigurations.newhostname = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     specialArgs = { inherit inputs; };
     modules = sharedModules ++ [
       ./hosts/newhostname
     ];
   };
   ```

### Adding New Applications

#### System-wide packages
Add to `hosts/shared/global/`, `hosts/shared/optional` or host-specific configuration.

#### User packages with Home Manager
Create a new file in `home/apps/myapp.nix`.
The file will be automatically imported by `home/nox.nix`.

### Creating Custom Overlays

1. Create a new overlay file in `overlays/`:
   ```nix
   final: prev: {
     my-package = prev.my-package.overrideAttrs (oldAttrs: {
       # Modifications here
     });
   }
   ```

2. Import it in `overlays/default.nix` if not already auto-imported.

## 🔧 Maintenance

### Regular Maintenance Tasks

1. **Update system regularly:**
   ```sh
   nix flake update && nh os switch --ask
   ```

2. **Clean old generations monthly:**
   ```sh
   nh clean all --keep 3
   ```

3. **Optimize nix store** (happens automatically daily, but can be run manually):
   ```sh
   nix-store --optimize
   ```

4. **Check for firmware updates:**
   ```sh
   fwupdmgr get-updates
   fwupdmgr update
   ```

5. **Update ClamAV definitions** (happens automatically, but can be run manually):
   ```sh
   sudo freshclam
   ```

### Troubleshooting

**System won't boot after update:**
- Select previous generation from systemd-boot menu
- Investigate and fix the issue
- Rebuild

**Out of disk space:**
```sh
# Delete old generations
sudo nix-collect-garbage -d
# Optimize store
nix-store --optimize
```

**Flake lock issues:**
```sh
# Update specific input
nix flake lock --update-input nixpkgs
# Or recreate lock file
rm flake.lock && nix flake update
```

## 📚 Additional Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [NixOS Discourse](https://discourse.nixos.org/)
- [Nix Pills Tutorial](https://nixos.org/guides/nix-pills/)

## 📝 Notes

- This configuration uses NixOS unstable channel for latest packages
- All hosts share a common base configuration with host-specific overrides
- Flakes ensure reproducible builds across all hosts
- The configuration uses `run0` as a sudo shim for systemd-run0 integration
- There is a sudo wrapper that uses `run0` behind the scenes
