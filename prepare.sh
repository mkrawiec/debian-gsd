#!/usr/bin/bash

set -e

apt-get install --no-install-recommends -y gpg gpg-agent ansible locales

if [ ! -f /tmp/ansible_extra_vars ]; then
    clear; read -p "Enter your username: " username
    adduser $username

    clear; read -p "Enter hostname: " hostname

    echo -n "username=$username hostname=$hostname" > /tmp/ansible_extra_vars

    clear; read -p "Install backported hardware stack [y/N] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -n " backported_hardware_stack=true" >> /tmp/ansible_extra_vars
    fi
fi

dpkg-reconfigure locales
dpkg-reconfigure tzdata
