# Nox' NixOS Configuration

This is Nox' NixOS configuration. 

## Quick start Nix installation notes

1. Load NixOS live CD;
1. Partition the disks (`cfdisk`):
    1. Create a /boot partition (fat32);
    1. Optionally add a swap partition;
    1. Optionally create btrfs swapfile (see below);
    1. Partition the rest of the space as btrfs.
1. Mount partitions to /mnt and /mnt/boot;
1. Create btrfs subvolumes, at least:
    1. /mnt/home;
    1. /mnt/nix;
    1. /mnt/root.
1. `nixos-generate-config --root /mnt`, keep the hardware config, delete the rest;
1. `git clone` this repo into `/etc/nixos`;
1. Put the generated hardware config into `./machines/$HOSTNAME-hw.nix`
1. `nixos-install --flake /mnt/etc/nixos#$HOSTNAME`;
1. `nixos-enter --root /mnt -c 'passwd nox'`;
1. `reboot`;
1. Move the configuration from `/etc/nixos` to `/home/nox/etc/nixos`;
1. `ln -s /home/nox/etc/nixos /etc/nixos`.

### Btrfs Swapfile Creation
```sh
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 16g /swap/Swapfile
```
