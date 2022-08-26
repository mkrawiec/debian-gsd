<div align="center">

# debian-gsd
![debian-gsd screenshot](https://user-images.githubusercontent.com/142805/186964547-48666722-5bbc-41e6-b930-8078345156d4.png)
</div>

--------

## Introduction

This project strives to deliver simple, rock-solid desktop workstation install. It's dedicated to advanced linux users - developers, sysadmins and enthusiasts.

## Features

- Minimal Debian Stable base, adapted as a plaform for running podman containers ([distrobox](https://github.com/89luca89/distrobox) included) and flatpak applications
- Automatic Btrfs snapshots and ability to boot read-only snapshots from the bootloader
- GNOME Desktop experience, that's close to stock, but with [refined defaults](ansible/roles/desktop/files/01-desktop-settings)
- Extras enabled by default - wireplumber, systemd-resolved, swap on zram, oom killer
- Backports and non-free repos enabled by default
- Configuration in form of ansible playbook, that is easy to extend and personalize

## Install

<table><tr><td><h3><a href="doc/install.md">Read instructions</a></h3></td></tr></table>
