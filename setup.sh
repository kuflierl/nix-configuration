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
dd if=/dev/zero of=$TGTDEV bs=4096 count=256K

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  g # clear the in memory partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512 MB boot parttion
  t # change type
  1 # set to type EFI
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  M # Enter MBR mode
  a # make a partition bootable
  #1 # bootable partition is partition 1 -- /dev/sda1
  r # return
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
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

cp config/* /mnt/etc/nixos/
