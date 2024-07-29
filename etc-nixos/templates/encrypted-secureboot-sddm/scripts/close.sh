#!/usr/bin/env bash
set -e
# config
LUKSNAME="nixos"

umount -R /mnt
cryptsetup close $LUKSNAME
