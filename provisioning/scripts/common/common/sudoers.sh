#!/usr/bin/env bash -eux

# Custom (section)

echo "# Allow SSH agent to be used with Sudo" >> /etc/sudoers.d/ssh_auth_sock
echo 'Defaults   env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers.d/ssh_auth_sock
