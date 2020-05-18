#!/usr/bin/env bash -eux

# Custom (All)

# Lock root account to prevent use, use cloud-init to create users with sudo as needed
passwd -l root;
echo "PermitRootLogin no" >> /etc/ssh/sshd_config;
