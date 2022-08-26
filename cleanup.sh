#!/usr/bin/bash

set -ex

apt-get remove -y --autoremove --purge ansible
rm -fr /usr/lib/python3/dist-packages/ansible_*
rm -fr $(dirname "$0")
