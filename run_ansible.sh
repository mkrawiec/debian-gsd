#!/usr/bin/bash

set -ex
export LC_ALL=C
export ANSIBLE_LOG_PATH=/var/log/ansible_run.log

ansible-playbook \
  --inventory "localhost," \
  --connection "local" \
  --extra-vars "$(cat /tmp/ansible_extra_vars)" \
  "$(dirname "$0")/ansible/root.yml"
