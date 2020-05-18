#!/usr/bin/env bash -eux

# Bento (Section)

# Remove development and kernel source packages
yum -y remove gcc cpp kernel-devel kernel-headers perl;
yum -y clean all;

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# clear the history so our install isn't there
export HISTSIZE=0

# remove the install log
rm -f /root/anaconda-ks.cfg
