# Installation

## Preparation

First, download [the latest installation image](https://github.com/mkrawiec/debian-gsd/releases) (you can also [build the image yourself](./building_liveiso.md)) and prepare an installation on a usb stick (with tools like `dd` or similar).

Next steps should be invoked from the target machine, booted from the live install media.

### Connect to the Internet
```
live# connmanctl
```
See [arch wiki](https://wiki.archlinux.org/title/ConnMan#Usage) for usage examples

### Get latest intaller files

The following command will download the latest version of this code and unpack it:
```
live# gsd-get
live# cd debian-gsd-master
```

## Partitioning

⚠️ Additional steps required in case of [full disk encryption](./disk_encryption.md). When using encrypted drives, replace `/dev/*` with `/dev/mapper/*`

```
live# fdisk /dev/sda # press (g) to create gpt partition table
live# cfdisk /dev/sda # set correct type on efi system partition
live# mkfs.btrfs /dev/sda1
live# mkfs.fat -F32 /dev/sda2
live# mkfs.xfs /dev/sda3
live# mkfs.xfs /dev/sda4
```

## Remount
```
live# ./bootstrap/create_subvolumes.sh /dev/sda1 /mnt
live# ./bootstrap/mount_root.sh /dev/sda1 /mnt
live# mount /dev/sda2 /mnt/boot/efi
live# mount /dev/sda3 /mnt/var
live# mount /dev/sda4 /mnt/home
```

## Debootstrap

```
live# debootstrap bullseye /mnt https://deb.debian.org/debian/
live# genfstab /mnt > /mnt/etc/fstab
live# cp -a . /mnt/opt/debian-gsd
```

⚠️ Additional steps required in case of [full disk encryption](./disk_encryption.md).

## Chroot configuration

```
live# arch-chroot /mnt
chroot# /opt/debian-gsd/prepare.sh
chroot# /opt/debian-gsd/run_ansible.sh
chroot# /opt/debian-gsd/cleanup.sh
```
