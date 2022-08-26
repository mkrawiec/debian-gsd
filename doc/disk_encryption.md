# Full disk encryption

## Before formating the drive

```
# create key file
dd bs=512 count=4 if=/dev/random of=/tmp/lukskey iflag=fullblock

# format containers
cryptsetup --type luks1 luksFormat /dev/sda1
cryptsetup luksAddKey /dev/sda1 /tmp/lukskey
cryptsetup --type luks1 luksFormat /dev/sda3 /tmp/lukskey
cryptsetup --type luks1 luksFormat /dev/sda4 /tmp/lukskey

# open containers
cryptsetup open /dev/sda1 root --key-file /tmp/lukskey
cryptsetup open /dev/sda3 var --key-file /tmp/lukskey
cryptsetup open /dev/sda4 home --key-file /tmp/lukskey
```

## Before entering chroot environment

```
# intall crypttab and the key
vi /mnt/etc/crypttab
> root /dev/sda1 /etc/keys/main.key luks
> var /dev/sda3 /etc/keys/main.key luks
> home /dev/sda4 /etc/keys/main.key luks

mkdir -p /mnt/etc/keys
cp /tmp/lukskey /mnt/etc/keys/main.key
```
