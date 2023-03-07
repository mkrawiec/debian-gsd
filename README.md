<div align="center">

# debian-gsd

![debian-gsd screenshot](https://user-images.githubusercontent.com/142805/186964547-48666722-5bbc-41e6-b930-8078345156d4.png)

</div>

---

## Introduction

This project is set of configuration and tools for Debian Stable. It strives to deliver rock-solid and refined desktop workstation install. It's dedicated to advanced linux users - developers, sysadmins and enthusiasts.

## Features

- Small Debian Stable base, adapted as a platform for running flatpaks and containers. Additionally [distrobox](https://github.com/89luca89/distrobox) comes preinstalled as a containerized environment for everyday software development. This creates a mix of rock-solid stable base and updated applications.
- Automatic Btrfs snapshots (via apt and snapper), the ability to boot from read-only snapshots and [rollback to a previous state](doc/user_guide.md#rolling-back-system-changes)
- GNOME Desktop experience, that's close to stock, but with [refined defaults](ansible/roles/desktop/files/01-desktop-settings)
- Extras enabled by default - wireplumber, systemd-resolved, swap on zram, oom killer
- Backports and non-free repos enabled by default
- Configuration in form of ansible playbook, that is easy to extend and personalize

## Install

<table><tr><td><h3><a href="doc/install.md">Read instructions</a></h3></td></tr></table>
