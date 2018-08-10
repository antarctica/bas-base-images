#!/usr/bin/env bash -eux

# Custom (All)

# This file relies on environment variables to provide template information. Required variables are:
# * TEMPLATE_NAME      equal to the 'proper' name of the template (e.g. antarctica/centos7)
# * TEMPLATE_NAME_ALT  equal to the 'safe' name of the template   (e.g. antarctica-centos7)
# * TEMPLATE_VERSION   equal to the version of the template       (e.g. 1.2.3)

# Create local facts directory
mkdir -p /etc/ansible/facts.d;

# Create fact file with template information - Produces a file like:
# ```
# [general]
# name=antarctica/centos7
# name_alt=antarctica-centos7
# version=1.2.3
# ````
printf "[general]\nname=$TEMPLATE_NAME\nname_alt=$TEMPLATE_NAME_ALT\nversion=$TEMPLATE_VERSION\n" > /etc/ansible/facts.d/os_template.fact;
