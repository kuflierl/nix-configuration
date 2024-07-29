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

cryptsetup open $LUKSPARTDEV $LUKSNAME

mount -o $BTRFS_OPT,subvol=@ $LUKSMAPPERDEV /mnt

mount -o $BTRFS_OPT,subvol=@home $LUKSMAPPERDEV /mnt/home/
mount -o $BTRFS_OPT,subvol=@nix $LUKSMAPPERDEV /mnt/nix/
mount -o $BTRFS_OPT,subvol=@nixos-config $LUKSMAPPERDEV /mnt/etc/nixos/
mount -o $BTRFS_OPT,subvol=@log $LUKSMAPPERDEV /mnt/var/log

mount -o rw,noatime $EFIPARTDEV /mnt/efi
