#!/usr/bin/env bash
set -e
# config
LUKSNAME="nixos"

umount /mnt
cryptsetup close $LUKSNAME
