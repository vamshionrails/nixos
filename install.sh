#!/bin/bash

# Specify the NVMe device
NVME_DEVICE="/dev/nvme0n1"

# Unmount all partitions
for partition in $(lsblk -o MOUNTPOINT $NVME_DEVICE | grep -v MOUNTPOINT | awk '{print $1}'); do
    umount $NVME_DEVICE$partition
done

# Delete existing partitions
parted $NVME_DEVICE mklabel gpt

echo "All partitions on $NVME_DEVICE have been unmounted and deleted."
