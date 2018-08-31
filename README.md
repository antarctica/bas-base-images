# BAS Base Images

A subset of customised [Packer](http://www.packer.io/) templates from [Bento](https://github.com/opscode/bento) for
creating virtual machine base images for use at BAS.

## Overview

### Supported operating systems

Each OS uses a separate Packer template/definition to create images for all [Supported providers](#supported-providers).

1. `antarctica/centos7` - Vanilla CentOS 7 (x86_64)

#### `antarctica-centos7`

Default distribution used at BAS. This template should be used by default.

[Customisations](#customisations) for the `VMware ESXi` provider image for this template are based on a [Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations) 
configuration file in `preseed/antarctica-centos7/ks.cfg`.

### Supported providers

1. VMware ESXi [1] - images are produced as [OVA](https://en.wikipedia.org/wiki/Open_Virtualization_Format) files ready 
   for [Deployment](#deployment)

[1] Specifically the development cluster at BAS Cambridge managed through vCentre

### Customisations

Various customisations have been applied to each [supported OS](#supported-operating-systems) to make them suitable for
use at BAS.

Some of these customisations are only applied to specific operating systems, or specific operating systems when used 
with a specific provider.

| Template             | Since Version | Category | Customisation                      | Description                                           |
| -------------------- | ------------- | -------- | ---------------------------------- | ----------------------------------------------------- |
| `antarctica/centos7` | `2018-08-10`  | System   | Swap file removed                  | Will be recreated for each template instance          |
| `antarctica/centos7` | `2018-08-10`  | System   | Network interfaces removed         | Bento recommendation                                  |
| `antarctica/centos7` | `2018-08-10`  | Security | SELinux disabled                   | As per BAS default, see [Security](#security)         |
| `antarctica/centos7` | `2018-08-10`  | Security | Firewall disabled                  | As per BAS default, see [Security](#security)         |
| `antarctica/centos7` | `2018-08-10`  | SSH      | `UseDNS` set to `no`               | Bento recommendation                                  |
| `antarctica/centos7` | `2018-08-10`  | SSH      | `GSSAPIAuthentication` set to `no` | Bento recommendation                                  |
| `antarctica/centos7` | `2018-08-10`  | SSH      | Host keys removed                  | To force new keys for each template instance          |
| `antarctica/centos7` | `2018-08-10`  | Sudo     | Passwordless sudo enabled          | To allow automated provisioning                       |
| `antarctica/centos7` | `2018-08-10`  | Sudo     | SSH Agent allowed using Sudo       | Normally blocked by env reset                         |
| `antarctica/centos7` | `2018-08-10`  | Locale   | Language set to `en_GB_UTF-8`      | As per regional default                               |
| `antarctica/centos7` | `2018-08-10`  | Locale   | Keyboard layout set to `uk`        | As per regional default                               |
| `antarctica/centos7` | `2018-08-10`  | Locale   | Timezone set to `UTC`              | As per BAS default                                    |
| `antarctica/centos7` | `2018-08-10`  | Users    | Root user password                 | Conventional default, see [Security](#security)       |
| `antarctica/centos7` | `2018-08-10`  | Users    | Root user authorized key           | Conventional default, see [Security](#security)       |
| `antarctica/centos7` | `2018-08-10`  | Packages | Yum upgrade                        | Updates all OS packages to latest versions            |
| `antarctica/centos7` | `2018-08-10`  | Packages | Yum clean                          | Package information, caches are removed               |
| `antarctica/centos7` | `2018-08-10`  | Packages | `sudo`, `wget` installed           | Required for installation                             |
| `antarctica/centos7` | `2018-08-10`  | Usage    | Ansible facts                      | For provisioning, see [Ansible facts](#ansible-facts) |

### Security

You **MUST** ensure when using these images that a appropriate level of security is in place for the data and services 
involved.

If in doubt contact [BAS IT](mailto:servicedesk@bas.ac.uk) for advice.

### Security features

By convention, the OS level firewall and security features such as SELinux are disabled on VMs running in BAS Cambridge.
For compatibility, this project follows these conventions, which may present a security risk if used outside of BAS
Cambridge (i.e. with a cloud provider).

### Root user

| Credential  | Value                                                                                         |
| ----------- | --------------------------------------------------------------------------------------------- |
| Username    | `root`                                                                                        |
| Password    | `password`                                                                                    |
| Private key | [Vagrant insecure private key](https://github.com/hashicorp/vagrant/blob/master/keys/vagrant) |

The root user credentials are set to intentionally insecure defaults to ensure they are changed as part of instance 
[Provisioning](#provisioning).

**Note:** Ideally the root user should not be able to login remotely, and should not be used directly. Instead per-user
accounts granted sudo rights should be used.

## Usage

### VMware vCentre (BAS Development cluster) (usage)

**Note:** It is assumed a template for the base image you want to use has already been created in your resource pool.
If not see the [Deployment](#deployment) section for more information.

1. login to the [BAS vCentre instance](https://bsv-vcsa-s1.nerc-bas.ac.uk/ui/) with your NERC AD credentials [1]
2. navigate to the relevant resource pool
3. from the left navigation, switch to the second view (*VMs and Templates), the template should be visible
4. from *ACTIONS* choose *New VM from This template*
5. choose a suitable name for the virtual machine
6. choose a suitable location (you will likely not have permission to deploy directly to the cluster)
7. choose a compute resource (this is almost always the same as the location)
8. select a suitable data store
9. review the details and finish
10. power on the virtual machine and complete any further [provisioning](#provisioning)

[1] Contact [BAS IT](mailto:servicedesk@bas.ac.uk) if you do not currently have access to vCentre

[2] The BAS vCentre instance currently uses a self-signed TLS certificate.

### Checksums

Where an image results in a file artefact, such as an OVA file, a checksum is generated to allow users to verify it 
hasn't been corrupted or modified outside of this project.

| Template            | Template Version | SHA 256 Checksum                                                   |
| ------------------- | ---------------- | ------------------------------------------------------------------ |
| `antarctica/trusty` | `2018-08-10`     | `5ec748ca961f021e6f7f8e8c383d9df1d2ad7796a254fe6001e31e49271ec089` |

## Provisioning

This section relates to provisioning instances of these templates, rather than provisioning used to build templates.

### Access

See [Root user](#root-user) for initial access credentials.

### Ansible

#### Ansible facts

To aid in provisioning, information about the template used for a virtual machine is made available as custom Ansible 
[facts](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html#information-discovered-from-systems-facts).

These facts report the name and version of the template used.

For example:

```
ok: [host] => {
    "msg": {
        "name": "antarctica/centos7",
        "name_alt": "antarctica-centos7",
        "version": "2018-08-10"
    }
}
```

An example playbook for reporting these facts is available in `usage/ansible/ansible-facts` To use with Docker and 
Docker Compose:

1. copy the `usage/ansible/ansible-facts` directory to a temporary location
2. `cd usage/ansible/ansible-facts`
3. set `ansible_host` in `inventory.yml` to the hostname of a VM
4. check your public key is allowed to access the VM and amend the volume for `/root/.ssh/id_rsa` in 
   `docker-compose.yml`
5. `docker-compose run ansible`
6. `ansible-playbook -i inventory.yml -u [username] site.yml`
7. exit and remove the Ansible container and `ansible-facts` directory

#### Bootstrap playbook

An Ansible playbook is available to secure a newly created VM by restricting the root user and creating individual 
accounts. 

**Note:** This playbook only needs to be ran once per VM, and only for non-cloud providers.

To use with Docker and Docker Compose:

1. copy the `usage/ansible/bootstrap` directory to a temporary location
2. `cd usage/ansible/bootstrap`
3. set `ansible_host` in `inventory.yml` to the IP address of the VM
4. set `hostname` in `host_vars/host.yml` to the intended VM hostname
5. populate the `users` dictionary as per [1] per user
6. `docker-compose run ansible`
7. `ansible-playbook -i inventory.yml site.yml`
8. exit and remove the Ansible container and `bootstrap` directory

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
| ------- | ---------- | ---------------------------------------------------------------- |
| `adm`   | Admin      | Default owner of some log files and other system level files     |
| `wheel` | Wheel      | System operators group, granted unrestricted, passwordless, sudo |

For example:

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

## Setup

To build images for a [template](#supported-operating-systems) run:

```
packer build -var 'release_version=[version]' definitions/[template].json
```

The `release_version` variable should be set to the date of building, in the form `YYYY-MM-DD`. E.g.

```
packer build -var 'release_version=2001-01-20' definitions/antarctica-centos7.json
```

Packer will build base images for each supported [Provider](#supported-providers) in parallel. It will apply any
[Customisations](#customisations) relevant to each template/provider and prepare it for [Deployment](#deployment).

For each artefact produced, a SHA 256 checksum will be generated alongside the file. This should be added to the 
[Checksums](#checksums) section to allow users to verify the artefact hasn't been corrupted or modified.

**Note:** It will take longer the first time you build a template as Packer needs to download the installation ISO for 
the OS.

## Deployment

Images for some [Providers](#supported-providers) are made locally and need deploying before they can be used.

**Note:** It is assumed images for a [Template](#supported-operating-systems) have already been produced. If not see 
the [Setup](#setup) section for more information.

### VMware vCentre (BAS Development cluster) (deployment)

The OVA file produced for the provider needs to be uploaded to vCentre and deployed as a virtual machine. This virtual
machine is then converted into a template, from which additional VMs can be made using the instructions in the 
[Usage](#usage) section.

To create a virtual machine from an OVF/OVA file:

1. login to the [BAS vCentre instance](https://bsv-vcsa-s1.nerc-bas.ac.uk/ui/) with your NERC AD credentials [1]
2. navigate to the relevant resource pool
3. from *ACTIONS* choose *Deploy OVF template*
4. ...
5. name the virtual machine in the form `base-[template]-[template-version]` e.g. `base-antarctica/centos7-2001-01-20`)
6. choose a suitable location (you will likely not have permission to deploy directly to the cluster)
7. choose a compute resource (this is almost always the same as the location)
8. VMware will check the template and display it's details
9. set the virtual disk format to *Thin Provision* and select a suitable data store
10. review the details and finish
11. select the new virtual machine, from *ACTIONS* choose *Edit settings*
12. choose *ADD NEW DEVICE* -> *Network Adapter*
13. ensure the network adapter uses the `DEV70` network
14. confirm the settings

To convert a virtual machine into a template:

1. select the virtual machine, from *ACTIONS* choose *Template* -> *Convert to Template*
2. confirm the warning
3. from the left navigation, switch to the second view (*VMs and Templates), the template should be visible

[1] Contact [BAS IT](mailto:servicedesk@bas.ac.uk) if you do not currently have access to vCentre

[2] The BAS vCentre instance currently uses a self-signed TLS certificate.

## Development

The Packer templates used for each [Operating System](#supported-operating-system) describe, for each
[Provider](#supported-providers), how to create each image (whether this is building a file, or creating a resource 
within a clouder provider), these are then customised and packaged ready for [Deployment](#deployment).

The templates used in this project are based on the templates and scripts development by the [Bento](https://github.com/opscode/bento) project. Bento offers a comprehensive range of operating systems and providers, 
creating vanilla, minimal images.

This project uses these templates and scripts as a stable foundation on which some elements are removed and others 
added in the form of [Customisations](#customisations).

* templates are kept in `definitions`, each template has *builders* for all supported providers
* various *provisioning* scripts from `provisioning/scripts` are used to apply customisations
* *builders* which produce artefacts output to a format-template directory within `artefacts`
* various *post-provisioning* scripts from `artefacts/scripts` are used to package artefacts for deployment

### Provisioning/Post-processing scripts

The scripts used for provisioning and post-provisioning are organised in the following structure:

* `scripts` - all scripts
    * `scripts/common` - scripts relevant to all operating systems
        * `scripts/common[environment]` - scripts relevant to a specific class of provider (e.g. `scripts/desktop`)
    * `scripts/[os]` - scripts relevant to a specific operating system (e.g. `scripts/centos`)
        * `scripts/[os]/[environment]` - see `scripts/common/[environment]`

Scripts are intentionally organised by OS not template as there may be multiple scripts based on the same OS and 
typically the only differences are in one or two scripts.

Currently only two provider classes are supported, *cloud* and *desktop* (which for this includes all VMware products).

Most scripts are copies, or adapted from, scripts used in the [Bento](https://github.com/opscode/bento) project. The
source of each script, or sections of a script, should indicate where it has come from (i.e. 'Bento' or 'Custom'). The
effects of any custom elements should be documented in the [Customisations](#customisations) section.

Scripts use the Bash interpreter with the `#!/usr/bin/env bash -eux` shebang to ensure compatibility across different operating systems. The options are:

* `e` - abort the script where a command returns a non-zero exit code (i.e. on first error)
* `u` - forces an exit if an undefined variable is used
* `x` - echoes each command before exiting it, rather than only displaying any output

## Testing

### Continuous Integration

All commits will trigger a Continuous Integration process using GitLab's CI/CD platform, configured in `.gitlab-ci.yml`.

This process will validate Packer definitions.

## Issue tracking

This project uses [issue tracking](https://gitlab.data.bas.ac.uk/WSF/bas-base-images/issues) to manage development of 
new features/improvements and reporting bugs.

## Feedback

The maintainer of this project is the BAS Web & Applications Team, they can be contacted through the 
[BAS Service Desk](mailto:servicedesk@bas.ac.uk).

## License

© UK Research and Innovation (UKRI), 2018, British Antarctic Survey.

You may use and re-use this software and associated documentation files free of charge in any format or medium, under 
the terms of the Open Government Licence v3.0.

You may obtain a copy of the Open Government Licence at http://www.nationalarchives.gov.uk/doc/open-government-licence/

This project includes material from the Chef Bento project, https://github.com/chef/bento, copyright Chef Software Inc.
See project [License](LICENSE.md) for more information.
