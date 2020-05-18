#!/usr/bin/env bash -eux

# Custom (All)

yum -y install open-vm-tools;
yum -y install cloud-init;
yum -y install epel-release;
yum -y install python-pip;
yum -y install http://bsl-repoa.nerc-bas.ac.uk/magic/v1/libraries/rpm/el7/noarch/cloud-init-vmware-guestinfo-1.1.0-1.el7.noarch.rpm;
# cloud-init-vmware-guestinfo python dependencies
pip install deepmerge==0.1.0 netifaces==0.10.9;
