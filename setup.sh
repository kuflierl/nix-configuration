#!/usr/bin/env bash
set -e
# config
TGTDEV="/dev/vda"
LUKSNAME="nixos"
BTRFS_OPT="rw,noatime,discard=async,compress-force=zstd,space_cache=v2,commit=120"

# generated
EFIPARTDEV="${TGTDEV}1"
LUKSPARTDEV="${TGTDEV}2"
LUKSMAPPERDEV="/dev/mapper/$LUKSNAME"


wipefs -a $TGTDEV

# 1. create a new gpt partition table
# 2. create the EFI partition
# 3. set partition flag esp to true (EFI boot)
# 4. fill the rest of the disk with btrfs
parted -s $TGTDEV \
  mklabel gpt \
  mkpart EFI fat32 1MB 512MB \
  set 1 esp on \
  mkpart root 512MB 100% \
  print

# set up efi partition
mkfs.fat -n EFI -F 32 $EFIPARTDEV
# set up crypto
cryptsetup luksFormat --type=luks1 $LUKSPARTDEV
cryptsetup open $LUKSPARTDEV $LUKSNAME
# set up btrfs
mkfs.btrfs -f -L NixOS $LUKSMAPPERDEV

mount -o $BTRFS_OPT $LUKSMAPPERDEV /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@nixos-config
btrfs subvolume create /mnt/@log

umount /mnt

mount -o $BTRFS_OPT,subvol=@ $LUKSMAPPERDEV /mnt
mkdir -p /mnt/home /mnt/nix /mnt/etc/nixos /mnt/var/log

mount -o $BTRFS_OPT,subvol=@home $LUKSMAPPERDEV /mnt/home/
mount -o $BTRFS_OPT,subvol=@nix $LUKSMAPPERDEV /mnt/nix/
mount -o $BTRFS_OPT,subvol=@nixos-config $LUKSMAPPERDEV /mnt/etc/nixos/
mount -o $BTRFS_OPT,subvol=@log $LUKSMAPPERDEV /mnt/var/log

mkdir -p /mnt/efi
mount -o rw,noatime $EFIPARTDEV /mnt/efi

# setup nix
nixos-generate-config --root /mnt
fsopts=$(awk -F, '{ for (i=1;i<=NF;i++) printf "\"%s\" ",$i}' <<< "$BTRFS_OPT")
sed -i -e "s/\"subvol=/$FSOPTS\"subvol=/g" /mnt/etc/nixos/hardware-configuration.nix

cp -r config/* /mnt/etc/nixos/
