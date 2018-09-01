#!/usr/bin/env bash -eux
# This script is only needed for cloud images as on desktops the kick-start process will configure the SELinux mode

# Set SELinux mode to 'disabled'
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux;
