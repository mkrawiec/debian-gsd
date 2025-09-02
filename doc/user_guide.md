# User Guide

## Rolling back system changes

To roll back the system to its previous state, reboot and choose the desired target snapshot in the GRUB boot menu.

Test the snapshot, and if the system works fine, roll back by creating a writable snapshot:

```
sudo snapper --ambit classic rollback
```

Reboot again and choose the default GRUB entry. Due to the limitations of the vanilla GRUB distribution (`/boot/grub/x86_64-efi` cannot reside on a Btrfs subvolume), it's necessary to reinstall the bootloader after the reboot:

```
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian
```

More information:

- https://doc.opensuse.org/documentation/leap/reference/html/book-reference/cha-snapper.html#sec-snapper-snapshot-boot
- https://manual.siduction.org/sys-admin-btrfs-snapper_en.html#snapper-rollback
