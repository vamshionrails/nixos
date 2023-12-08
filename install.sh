#!/bin/bash

# Specify the NVMe device
NVME_DEVICE="/dev/nvme0n1"

# Forcefully format the partitions
mkfs.fat -F 32 -f ${NVME_DEVICE}p1     # Forcefully format EFI partition as FAT32
mkfs.btrfs -L nixos -f ${NVME_DEVICE}p2 # Forcefully format root partition as Btrfs

# Delete existing partitions
parted $NVME_DEVICE rm 1 2 &>/dev/null

# Partition the NVMe drive
parted $NVME_DEVICE mklabel gpt
parted $NVME_DEVICE mkpart primary 1MiB 512MiB    # EFI partition
parted $NVME_DEVICE mkpart primary 512MiB 100%    # Root partition

# Format the partitions
mkfs.fat -F 32 ${NVME_DEVICE}p1     # Format EFI partition as FAT32
mkfs.btrfs -L nixos ${NVME_DEVICE}p2 # Format root partition as Btrfs

# Mount the root partition
mount ${NVME_DEVICE}p2 /mnt

# Create subvolumes for Btrfs
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

# Unmount the root partition
umount /mnt

# Mount subvolumes
mount -o subvol=@ ${NVME_DEVICE}p2 /mnt
mkdir -p /mnt/home
mount -o subvol=@home ${NVME_DEVICE}p2 /mnt/home
