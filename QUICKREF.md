# Quick Reference Guide

A cheat sheet for common operations and commands in this NixOS configuration.

## 🔄 System Management

### Rebuild System
```bash
# Rebuild and switch to new configuration
nh os switch --ask

# Traditional method
sudo nixos-rebuild switch --flake .#$HOSTNAME

# Test without making permanent (reverts on reboot)
sudo nixos-rebuild test --flake .#$HOSTNAME

# Build without activating
nh os build
```

### Update System
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Update and rebuild
nix flake update && nh os switch
```

### Rollback
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Boot into previous generation (select from boot menu)
# Reboot and choose generation from systemd-boot
```

## 🧹 Cleanup

### Remove Old Generations
```bash
# Using nh (keeps last 3 generations)
nh clean all --keep 3

# Manual cleanup (deletes all old generations)
sudo nix-collect-garbage -d

# Delete generations older than 30 days
sudo nix-collect-garbage --delete-older-than 30d
```

### Optimize Store
```bash
# Optimize nix store (deduplicate files)
nix-store --optimize

# Check store integrity
nix-store --verify --check-contents
```

### Disk Usage
```bash
# Check nix store size
du -sh /nix/store

# List largest packages
nix-store --query --requisites /run/current-system | xargs du -sh | sort -h
```

## 📦 Package Management

### Search Packages
```bash
# Search in nixpkgs
nh search package-name

# Search with more details
nix search nixpkgs package-name --json

# Browse online
# https://search.nixos.org/packages
```

### Install Packages Temporarily
```bash
# Run package without installing
nix shell nixpkgs#package-name

# Run command from package
nix run nixpkgs#package-name

# Multiple packages
nix shell nixpkgs#pkg1 nixpkgs#pkg2
```

### Install Packages Permanently
Add to appropriate file:
- System-wide: `hosts/shared/global/*.nix` or host-specific
- User-level: `home/apps/*.nix`

## 🔍 Diagnostics

### Check Configuration
```bash
# Check for syntax errors
nix flake check --no-build

# Show configuration
nixos-option system.stateVersion

# Show all options
nixos-option --recursive
```

### View Logs
```bash
# System logs
journalctl -b                    # Current boot
journalctl -b -1                 # Previous boot
journalctl -f                    # Follow logs
journalctl -u service-name       # Specific service
journalctl -p err                # Only errors

# Last boot messages
dmesg
```

### Service Management
```bash
# Status
systemctl status service-name

# Start/Stop/Restart
sudo systemctl start service-name
sudo systemctl stop service-name
sudo systemctl restart service-name

# Enable/Disable
sudo systemctl enable service-name
sudo systemctl disable service-name

# List all services
systemctl list-units --type=service
```

## 🔧 Development

### Enter Development Shell
```bash
# Shell with specific packages
nix shell nixpkgs#gcc nixpkgs#cmake

# From flake.nix devShell
nix develop
```

### Build Derivation
```bash
# Build a package
nix build .#package-name

# Build and create result symlink
nix build nixpkgs#package-name
```

### Evaluate Nix Expression
```bash
# Evaluate expression
nix eval .#nixosConfigurations.hostname.config.networking.hostName

# Show derivation
nix show-derivation .#package-name
```

## 🖥️ Hardware

### Update Firmware
```bash
# Check for updates
fwupdmgr get-updates

# Update firmware
fwupdmgr update

# Refresh metadata
fwupdmgr refresh
```

### GPU Information
```bash
# AMD GPU (ROCm)
rocm-smi

# General GPU info
lspci | grep VGA
glxinfo | grep "OpenGL renderer"
```

### Disk Information
```bash
# SMART status
sudo smartctl -a /dev/sdX

# Btrfs info
sudo btrfs filesystem usage /
sudo btrfs filesystem df /

# Disk usage by subvolume
sudo btrfs subvolume list /
```

## 🎮 Gaming

### Steam
```bash
# Launch Steam
steam

# Force specific Proton version
STEAM_COMPAT_DATA_PATH=~/.proton steam
```

### Lutris
```bash
# Launch Lutris
lutris

# List games
lutris -l
```

### Wine
```bash
# Run Windows application
wine application.exe

# Configure Wine
winecfg
```

## 🔐 Security

### ClamAV
```bash
# Update virus definitions
sudo freshclam

# Scan directory
clamscan -r /path/to/scan

# Scan home directory
clamscan -r ~
```

### Firewall
```bash
# List firewall rules
sudo iptables -L

# Check firewall status
sudo systemctl status firewall
```

## 🌐 Network

### NetworkManager
```bash
# List connections
nmcli connection show

# Connect to WiFi
nmcli device wifi connect SSID password PASSWORD

# Show device status
nmcli device status

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

### DNS
```bash
# Check DNS resolution
resolvectl status

# Flush DNS cache
sudo resolvectl flush-caches
```

## 💾 Virtualization

### libvirt/QEMU
```bash
# List VMs
virsh list --all

# Start VM
virsh start vm-name

# Stop VM
virsh shutdown vm-name

# Force stop
virsh destroy vm-name

# Open virt-manager GUI
virt-manager
```

### Waydroid (Android)
```bash
# Start Waydroid
waydroid show-full-ui

# First-time setup
waydroid init

# Session management
waydroid session start
waydroid session stop
```

## 📝 Configuration Files

### Important Locations
```
/etc/nixos/                          # System configuration (simlink to /home/nox/etc/nixos/)
~/.config/                           # User configuration
/nix/store/                          # Nix packages
/run/current-system/                 # Current system generation
~/.local/state/home-manager/         # Home-manager generations
```

### Edit Configuration
```bash
# Edit with default editor
$EDITOR ~/etc/nixos/flake.nix

# Edit specific module
$EDITOR ~/etc/nixos/hosts/shared/global/kde.nix
```

## 🔄 Git Operations

### Common Git Commands
```bash
# Status
git status

# Add changes
git add .

# Commit
git commit -m "description"

# Push
git push

# Pull updates
git pull

# View history
git log --oneline
```

## 🆘 Emergency Recovery

### Boot Issues
1. Select previous generation from systemd-boot menu
2. Press 'd' to view all generations
3. Select working generation

### Fix Broken System
```bash
# Boot from NixOS ISO
# Mount root filesystem
sudo mount /dev/sdXY /mnt

# Chroot into system
sudo nixos-enter --root /mnt

# Rollback
sudo nixos-rebuild switch --rollback

# Or edit configuration and rebuild
sudo nixos-rebuild switch
```

### Reset Home Manager
```bash
# Remove home-manager state
rm -rf ~/.local/state/home-manager

# Rebuild
nh os switch
```

## 📊 Monitoring

### System Information
```bash
# Comprehensive Monitoring
btop

# CPU info
lscpu

# Memory usage
free -h

# Disk usage
df -h

# System uptime
uptime

# Process list
top   # or top
```

## 🚀 Quick Tips

- Use `nix shell` for temporary packages instead of installing globally
- Keep at least 3 generations for easy rollback
- Run `nh clean all --keep 3` monthly to save disk space
- Update regularly with `nix flake update`
- Check `journalctl -p err` after rebuilds for errors
- Test changes with `nixos-rebuild test` before committing
- Use `nix search` to find package names
- Back up important data before major updates
- Document custom changes in git commit messages

## 🔗 Useful Links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Options Search](https://search.nixos.org/options)
- [NixOS Package Search](https://search.nixos.org/packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS Wiki](https://nixos.wiki/)
