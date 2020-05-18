#!/usr/bin/env bash -eux

# Custom (All)

# This file relies on environment variables to provide template information. Required variables are:
# * TEMPLATE_NAME      equal to the name of the template (e.g. antarctica-centos7)
# * TEMPLATE_VERSION   equal to the version of the template (e.g. 2012-07-20)

# Create local facts directory
mkdir -p /etc/ansible/facts.d;

# Create fact file with template information - Produces a file like:
# ```
# [general]
# name=antarctica-centos7
# version=2012-07-20
# ````
printf "[general]\nname=$TEMPLATE_NAME\nversion=$TEMPLATE_VERSION\n" > /etc/ansible/facts.d/os_template.fact;
