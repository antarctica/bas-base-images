#!/usr/bin/env bash -eux

# Bento (All)

# Remove host keys to ensure unique keys are used for each instance of template
rm -f /etc/ssh/*key*;
