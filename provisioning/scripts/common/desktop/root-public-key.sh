#!/usr/bin/env bash

# Custom (All)

mkdir ~/.ssh
wget 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' -O ~/.ssh/authorized_keys
chown -R root ~/.ssh
chmod -R go-rwsx ~/.ssh
