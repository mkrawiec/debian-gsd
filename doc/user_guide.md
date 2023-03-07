# User guide

## Rolling back system changes

To rollback the system to it's previous state, reboot and choose desired target snapshot in the grub boot menu.

Test the snapshot, and if the system works fine, rollback by creating a writable snapshot:

```
sudo snapper --ambit classic rollback
```

Reboot again and choose the default grub entry. Due to the limitations of vanilla grub distribution (`/boot/grub/x86_64-efi` cannot reside on a btrfs subvolume), it's necessary to reinstall the bootloader after the reboot:

```
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian
```

More info:

- https://doc.opensuse.org/documentation/leap/reference/html/book-reference/cha-snapper.html#sec-snapper-snapshot-boot
- https://manual.siduction.org/sys-admin-btrfs-snapper_en.html#snapper-rollback
