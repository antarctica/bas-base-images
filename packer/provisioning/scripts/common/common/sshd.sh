#!/usr/bin/env bash -eux

# Bento (Section)

echo "UseDNS no" >> /etc/ssh/sshd_config;
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config;
