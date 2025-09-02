# Installation

The installation process is semi-automatic, requiring manual preparation of the target machine followed by running automated Ansible playbooks to bootstrap system configuration.

## Live media preparation

First, download [the latest installation image](https://github.com/mkrawiec/debian-gsd/releases) (you can also [build the image yourself](./building_liveiso.md)) and prepare a USB stick with the installation image (using tools like `dd` or similar).

To complete the setup, the target machine must meet these requirements:

- Modern hardware with UEFI support
- At least 20 GB of disk space
- Network connectivity

🆙 If you plan to test the installation in a virtual machine, make sure that UEFI support is enabled first. In VirtualBox, check the _"Enable EFI (special OSes only)"_ option. In libvirt/GNOME Boxes, replace `<os>` with `<os firmware="efi">` in the configuration XML file.

## Boot

After booting the machine from the live media, first become the root user.

```
live$ sudo -i
```

Next, to connect to a wireless network, use Connman. See the [Arch Wiki](https://wiki.archlinux.org/title/ConnMan#Usage) for examples on how to use it.

```
live# connmanctl
```

The following commands will fetch the latest version of this repository and unpack it:

```
live# gsd-get
live# cd debian-gsd-master
```

## Partitioning

This section presents an example partitioning schema. It can be customized to your needs; however, two constraints should be kept in mind: the root partition should be formatted as the Btrfs filesystem, and an EFI partition should be created.

After identifying the target disk, make sure that it has a GPT partition table. In order to wipe out the disk and create a GPT table, use:

```
live# fdisk /dev/<disk>
```

Press _(g)_ to create a GPT partition table, then _(w)_ to write to disk.

Then run `cfdisk` to start partitioning the disk.

```
live# cfdisk /dev/<disk>
```

### Recommended schema

The table below shows the recommended partition layout. It assumes that the target disk is `/dev/sda`, so it should be adapted to your actual disk name. For convenience, when running commands from this document, you can export the values from the column _Partition variable_ (e.g. `export dev_root=/dev/sda1`).

| Partition variable | Value w/o disk encryption | Value with disk encryption  | Size                             |
| ------------------ | ------------------------- | -------------------------- | -------------------------------- |
| `$dev_root`        | /dev/sda1                 | /dev/mapper/root           | Minimum 5GB, recommended 20-50GB |
| `$dev_efi`         | /dev/sda2                 | /dev/sda2                  | 100-500MB                        |
| `$dev_var`         | /dev/sda3                 | /dev/mapper/var            | Minimum 5GB, recommended >50GB   |
| `$dev_home`        | /dev/sda4                 | /dev/mapper/home           | Whatever is left                 |

This is how it looks in `cfdisk`:

![finished partitioning](https://user-images.githubusercontent.com/142805/189527491-30371b9c-1de1-48ec-81f2-2d5928e7da3c.png)

🆙 Note that the EFI partition is of type _EFI System_; this is important for correct identification of the EFI partition on a running system.

## Format the partitions

⚠️ Additional steps are required in case of [full disk encryption](./disk_encryption.md).

```
live# mkfs.btrfs $dev_root
live# mkfs.fat -F32 $dev_efi
live# mkfs.xfs $dev_var
live# mkfs.xfs $dev_home
```

## Mount the partitions

Before we can bootstrap and chroot into the system, we need to create the correct mount points and Btrfs subvolumes.

```
live# ./bootstrap/create_subvolumes.sh $dev_root /mnt
live# ./bootstrap/mount_root.sh $dev_root /mnt
live# mount $dev_efi /mnt/boot/efi
live# mount $dev_var /mnt/var
live# mount $dev_home /mnt/home
```

## Debootstrap

```
live# debootstrap bookworm /mnt https://deb.debian.org/debian/
live# genfstab /mnt > /mnt/etc/fstab
live# cp -a . /mnt/opt/debian-gsd
```

⚠️ Additional steps are required in case of [full disk encryption](./disk_encryption.md).

## Chroot configuration

Change root and run the preparation script; it will prompt for user information, hostname, locale, and timezone.

```
live# arch-chroot /mnt
chroot# /opt/debian-gsd/prepare.sh
```

Run the Ansible playbook—this is the main step of target system configuration. You can modify the playbook under the `/opt/debian-gsd/ansible/` directory and rerun this step as many times as needed. In case of failure, detailed logs of the Ansible run are stored in `/var/log/ansible_run.log`.

```
chroot# /opt/debian-gsd/run_ansible.sh
```

Clean up installation scripts and their dependencies that are no longer required.

```
chroot# /opt/debian-gsd/cleanup.sh
```

Unmount and reboot

```
chroot# exit
live# umount -R /mnt
live# reboot
```
