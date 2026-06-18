#!/usr/bin/env bash
set -e # Exit immediately if a command exits with a non-zero status

# CHANGE THIS to your target disk
DISK="/dev/sda"
PART_BOOT="${DISK}1"
PART_ROOT="${DISK}2"

# If using NVMe, partitions are usually named like /dev/nvme0n1p1, /dev/nvme0n1p2
if [[ "$DISK" == *"nvme"* ]]; then
    PART_BOOT="${DISK}p1"
    PART_ROOT="${DISK}p2"
fi

echo "=== 2. Partitioning Disk: ${DISK} ==="
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK" -- set 1 boot on
parted "$DISK" -- mkpart primary ext4 512MiB 100%

echo "=== 3. Formatting Partitions ==="
mkfs.vfat -F 32 -n boot "$PART_BOOT"
mkfs.ext4 -F -L nixos "$PART_ROOT"

echo "=== 4. Mounting Filesystems ==="
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "=== 5. Generating Base Configuration ==="
nixos-generate-config --root /mnt

echo "=== 6. Opening Configuration File ==="
echo "Add 'programs.hyprland.enable = true;' and your user account settings now."
read -p "Press [Enter] to open nano..."
nano /mnt/etc/nixos/configuration.nix

echo "=== 7. Installing NixOS ==="
nixos-install

reboot