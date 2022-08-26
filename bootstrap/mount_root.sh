#!/usr/bin/bash

set -ex

DEVICE=$1
MOUNTPOINT=$2

mount -o subvol=@/.snapshots/1/snapshot $DEVICE $MOUNTPOINT
mkdir -p $MOUNTPOINT/{.snapshots,opt,root,srv,tmp,var,home,usr/local,boot/efi}
mount -o subvol=@/.snapshots $DEVICE $MOUNTPOINT/.snapshots
mount -o subvol=@/opt $DEVICE $MOUNTPOINT/opt
mount -o subvol=@/root $DEVICE $MOUNTPOINT/root
mount -o subvol=@/srv $DEVICE $MOUNTPOINT/srv
mount -o subvol=@/usr/local $DEVICE $MOUNTPOINT/usr/local
