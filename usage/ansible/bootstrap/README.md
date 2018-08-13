Change lines in inventory.yml
Change lines in host_vars/host.yml


* set `ansible_host` in `inventory.yml`
* set `hostname` in `host_vars/host.yml`
* populate the `users` dictionary as per [1] per user

[1]

| Option               | Data Type        | Description                               | Notes                                    |
| -------------------- | ---------------- | ----------------------------------------- | ---------------------------------------- |
| `name`               | String           | username of user                          | By convention - NUREM username           |
| `gecos`              | String           | descriptive name                          | By convention - 'Firstname Lastname'     |
| `groups`             | Array of Strings | List of groups user should be a member of | Groups must already exist                |
| `shell`              | String           | Shell for user                            | By convention - '/bin/bash'              |
| `ssh_authorized_key` | String           | Public key                                | By convention with user email as comment |

Conventional groups:

| Group   | Group Name | Description                                                      |
| 
| `adm`   | Admin      | Default owner of some log files and other system level files     |
| `wheel` | Wheel      | System operators group, granted unrestricted, passwordless, sudo |

Example:

```yaml
users:
  - 
    name: conwat
    gecos: Connie Watson
    groups:
      - adm
      - wheel
    shell: /bin/bash
    ssh_authorized_key: "ssh-rsa AAAAB...x conwat@bas.ac.uk"
```
