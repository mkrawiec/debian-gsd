#!/usr/bin/bash

set -ex

DEVICE=$1
MOUNTPOINT=$2

mount -o subvolid=5 $DEVICE $MOUNTPOINT
btrfs subvolume create $MOUNTPOINT/@
btrfs subvolume create $MOUNTPOINT/@/.snapshots
mkdir -p $MOUNTPOINT/@/.snapshots/1
btrfs subvolume create $MOUNTPOINT/@/.snapshots/1/snapshot
btrfs subvolume create $MOUNTPOINT/@/opt
btrfs subvolume create $MOUNTPOINT/@/root
btrfs subvolume create $MOUNTPOINT/@/srv
mkdir -p $MOUNTPOINT/@/usr/
btrfs subvolume create $MOUNTPOINT/@/usr/local

root_subvol_id=$(btrfs subvolume list $MOUNTPOINT | grep .snapshots/1/snapshot | awk '{print $2}')
btrfs subvolume set-default $root_subvol_id $MOUNTPOINT

umount $MOUNTPOINT
