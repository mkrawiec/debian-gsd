# Installation

Installation process is semi-automatic, requiring manual preparation of the target machine and then running automated ansible playbooks, to bootstrap system configuration.

## Live media preparation

First, download [the latest installation image](https://github.com/mkrawiec/debian-gsd/releases) (you can also [build the image yourself](./building_liveiso.md)) and prepare an installation on a usb stick (with tools like `dd` or similar).

To be able to complete the setup, target machine must meet the requirements:

- Modern hardware with UEFI support
- At least 20 GB of disk space
- Network connectivity

🆙 If you plan to test the install in virtual machine, make sure that UEFI support is enabled first (In VirtualBox - check _"Enable EFI (special OSes only)"_ option, in libvirt/GNOME Boxes - replace `<os>` with `<os firmware="efi">` in configuration xml file)

## Boot

After booting the machine from live media, first become root user.

```
live$ sudo -i
```

Next, for connecting to wireless network, use Connman. See [arch wiki](https://wiki.archlinux.org/title/ConnMan#Usage) for examples, how to use it.

```
live# connmanctl
```

The following command will fetch the latest version of this repository and unpack it:

```
live# gsd-get
live# cd debian-gsd-master
```

## Partitioning

This section presents an example partitioning schema. It can be customized to user's need, however two constraints should be kept in mind - root partition should be formatted as Btrfs filesystem and efi partition should be created.

After identifying target disk, make sure that it has GPT partition table. In order to wipe out the disk and create GPT table use:

```
live# fdisk /dev/<disk>
```

Press _(g)_ to create gpt partition table, then _(w)_ to write to disk

Then run `cfdisk`, to start partitioning the disk.

```
live# cfdisk /dev/<disk>
```

### Recommended schema

The table below shows recommended partition layout. It assumes that the target disk is `/dev/sda`, so it should be adapted to the disk name. For convenience when running commands from the doc, you can export the values form the column _Partition variable_ (e.g. `export dev_root=/dev/sda1`).

| Partition variable | Value w/o disk encryption | Value with disc encryption | Size                             |
| ------------------ | ------------------------- | -------------------------- | -------------------------------- |
| `$dev_root`        | /dev/sda1                 | /dev/mapper/root           | Minimum 5GB, recommended 20-50GB |
| `$dev_efi`         | /dev/sda2                 | /dev/sda2                  | 100-500MB                        |
| `$dev_var`         | /dev/sda3                 | /dev/mapper/var            | Minimum 5GB, recommended >50GB   |
| `$dev_home`        | /dev/sda4                 | /dev/mapper/home           | Whatever is left                 |

This is how it looks in `cfdisk`:

![finished partitioning](https://user-images.githubusercontent.com/142805/189527491-30371b9c-1de1-48ec-81f2-2d5928e7da3c.png)

🆙 Note that efi partition is of type _EFI System_, this is important for correct identification of EFI partition on running system.

## Format the partitions

⚠️ Additional steps required in case of [full disk encryption](./disk_encryption.md)

```
live# mkfs.btrfs $dev_root
live# mkfs.fat -F32 $dev_efi
live# mkfs.xfs $dev_var
live# mkfs.xfs $dev_home
```

## Mount the partitions

Before we can bootstrap and chroot to the system, we need to create correct mount points and Btrfs subvolumes.

```
live# ./bootstrap/create_subvolumes.sh $dev_root /mnt
live# ./bootstrap/mount_root.sh $dev_root /mnt
live# mount $dev_efi /mnt/boot/efi
live# mount $dev_var /mnt/var
live# mount $dev_home /mnt/home
```

## Debootstrap

```
live# debootstrap bullseye /mnt https://deb.debian.org/debian/
live# genfstab /mnt > /mnt/etc/fstab
live# cp -a . /mnt/opt/debian-gsd
```

⚠️ Additional steps required in case of [full disk encryption](./disk_encryption.md).

## Chroot configuration

Change root and run preparation script, it will prompt for user information, hostname, locale and timezone.

```
live# arch-chroot /mnt
chroot# /opt/debian-gsd/prepare.sh
```

Run ansible playbook - this is the main step of target system configuration. You can modify the playbook under `/opt/debian-gsd/ansible/` directory and rerun this step as many times as needed. In case of failure, detailed logs of ansible run are stored in `/var/log/ansible_run.log`.

```
chroot# /opt/debian-gsd/run_ansible.sh
```

Clean up installation scripts and it's dependencies that are no longer required.

```
chroot# /opt/debian-gsd/cleanup.sh
```

Umount and reboot

```
chroot# exit
live# umount -R /mnt
live# reboot
```
