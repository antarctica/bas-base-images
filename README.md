# BAS Base Images

A subset of customised [Packer](http://www.packer.io/) templates from [Bento](https://github.com/opscode/bento) for
creating virtual machine base images for use at BAS.

## Overview

### Supported distributions

Each supported distribution is defined by a Packer template. It describes how to create artefacts for each 
[Supported provider](#supported-providers) applying any relevant [Customisations](#customisations).

| Template                                  | Distribution | Version | Architecture |
| ----------------------------------------- | ------------ | ------- | ------------ |
| [antarctica-centos7](#antarctica-centos7) | CentOS       | 7.x     | *x86_64*     |

#### antarctica-centos7

The default distribution used at BAS.

Many of the [Customisations](#customisations) relevant to the artefact produced for the *VMware ESXi* provider are
applied using a
[Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations) 
configuration file in `preseed/antarctica-centos7/ks.cfg`.

### Supported providers

Each Packer template, for each [Supported distribution](#supported-distributions), describes how to produce an artefact
suitable for each supported provider. These artefacts can be used to create instances of a template with each provider.

| Provider     | Type    | Artefact Type                                                        |
| ------------ | ------- | -------------------------------------------------------------------- |
| VMware ESXi  | Desktop | [OVA](https://en.wikipedia.org/wiki/Open_Virtualization_Format) file |

### Customisations

Various customisations are applied when building artefacts for each template to make them suitable for use at BAS. 
Customisations may be applied globally or to combinations of specific [Distributions](#supported-distributions) or 
[Providers](#supported-providers).

Each customisation applies from a template 'version', which represents the date at which the customisation was applied.
Typically customisations are made in groups and thus share a version.

| Template           | Since Version | Category | Customisation                      | Rational                                                          |
| ------------------ | ------------- | -------- | ---------------------------------- | ----------------------------------------------------------------- |
| antarctica-centos7 | *2018-08-10*  | System   | Swap file removed                  | Swap will be recreated for each instance if needed                |
| antarctica/centos7 | *2018-08-10*  | System   | Network interfaces removed         | From Bento project                                                |
| antarctica/centos7 | *2018-08-10*  | Security | SELinux disabled                   | BAS convention, see [Security](#security)                         |
| antarctica/centos7 | *2018-08-10*  | Security | Firewall disabled                  | BAS convention, see [Security](#security)                         |
| antarctica/centos7 | *2018-08-10*  | SSH      | `UseDNS` set to `no`               | From Bento project                                                |
| antarctica/centos7 | *2018-08-10*  | SSH      | `GSSAPIAuthentication` set to `no` | From Bento project                                                |
| antarctica/centos7 | *2018-08-10*  | SSH      | Host keys removed                  | Keys will be recreated for each instance                          |
| antarctica/centos7 | *2018-08-10*  | Sudo     | Passwordless sudo enabled          | To allow for automated provisioning                               |
| antarctica/centos7 | *2018-08-10*  | Sudo     | SSH Agent allowed using Sudo       | To allow connecting through other hosts using private keys        |
| antarctica/centos7 | *2018-08-10*  | Locale   | Language set to `en_GB_UTF-8`      | Regional default                                                  |
| antarctica/centos7 | *2018-08-10*  | Locale   | Keyboard layout set to `uk`        | Regional default                                                  |
| antarctica/centos7 | *2018-08-10*  | Locale   | Timezone set to `UTC`              | Regional default and BAS convention                               |
| antarctica/centos7 | *2018-08-10*  | Users    | Root user password                 | To allow for automated provisioning, see [Security](#security)    |
| antarctica/centos7 | *2018-08-10*  | Users    | Root user authorized key           | To allow for automated provisioning, see [Security](#security)    |
| antarctica/centos7 | *2018-08-10*  | Packages | Yum upgrade                        | To update all OS packages to latest versions                      |
| antarctica/centos7 | *2018-08-10*  | Packages | Yum clean                          | To reduce size of artefacts removing unnecessary files and caches |
| antarctica/centos7 | *2018-08-10*  | Packages | `sudo`, `wget` installed           | Required for installation                                         |
| antarctica/centos7 | *2018-08-10*  | Usage    | Ansible facts                      | For automated provisioning, see [Ansible facts](#ansible-facts)   |

### Security

You **MUST** ensure that a appropriate level of security is in place for any data stored in, and services ran on, any 
use of these templates. If in doubt contact [BAS IT](mailto:servicedesk@bas.ac.uk) for advice.

### Security features

By convention, the OS level firewall and security features such as SELinux are disabled on VMs running in BAS Cambridge.

For compatibility, this project follows these conventions, which may present a security risk if used outside of BAS
Cambridge (i.e. with a cloud provider).

### Root user

Root user credentials are intentionally set to insecure defaults to ensure they are changed as part of instance 
[Provisioning](#provisioning).

| Credential  | Value                                                                                         |
| ----------- | --------------------------------------------------------------------------------------------- |
| Username    | `root`                                                                                        |
| Password    | `password`                                                                                    |
| Private key | [Vagrant insecure private key](https://github.com/hashicorp/vagrant/blob/master/keys/vagrant) |

## Usage

### VMware vCentre (BAS Development cluster) (usage)

**Note:** It is assumed a VMware template for the Packer template you wish to use has already been created in your 
resource pool. If not see the [Deployment](#deployment) section for more information.

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


### Artefact Checksums

Where artefacts produce a file, such as an OVA, a checksum is generated to protect against corruption or modification.

| Template            | Template Version | SHA 256 Checksum                                                   |
| ------------------- | ---------------- | ------------------------------------------------------------------ |
| `antarctica/trusty` | `2018-08-10`     | `5ec748ca961f021e6f7f8e8c383d9df1d2ad7796a254fe6001e31e49271ec089` |

### Instance Provisioning

This section describes how to use instances of artefacts built from this project.

#### Access

See the [Root user](#root-user) section for initial access credentials.





#### Ansible

##### Ansible facts

To aid in provisioning, information about the template artefact instances are created from is made available as 
[Ansible facts](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html#information-discovered-from-systems-facts).

These facts report the name and version of the template used.

For example:

```
ok: [host] => {
    "msg": {
        "name": "antarctica-centos7",
        "version": "2018-08-10"
    }
}
```

An example reporting playbook is available in [usage/ansible/ansible-facts](/usage/ansible/ansible-facts).

##### Ansible bootstrap

An Ansible playbook is available in [usage/ansible/ansible-bootstrap](usage/ansible/ansible-bootstrap) to initially 
secure instances created from these template artefacts.

It creates a set of individual user accounts, with authorised public keys, and disables the 
[initial access credentials](#root-user). It only needs to be ran once per instance.

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

To build artefacts for each provider defined in a Packer template:

```shell
$ packer build templates/[template].json
# E.g.
$ packer build templates/antarctica-centos7.json
```

Artefacts will be created in parallel, applying any relevant [Customisations](#customisations) ready for 
[Deployment](#deployment).

If needed, artefacts for a single provider can be built:

```
$ packer build --only=[provider] templates/[template].json
# E.g.
$ packer build --only=digitalocean templates/antarctica-centos7.json
```

For providers which produce artefacts as files, a SHA 256 checksum will be generated. Add this value to the 
[Checksums](#checksums) section.

**Note:** It will take longer the first time you build a template, as for some providers Packer needs to download the 
installation ISO for the OS.

## Deployment

Artefacts for some [Providers](#supported-providers) are built locally and need deploying before they can be used.

**Note:** Artefacts for a template should have already been built. If not, see the [Setup](#setup) section.

### VMware vCentre (BAS Development cluster) (deployment)

The OVA file produced needs to be uploaded to vCentre and deployed as a virtual machine. This virtual machine is then 
converted into a template, from which additional VMs can be made using the instructions in the [Usage](#usage) section.

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

The Packer templates used in this project are based on the templates and provisioning scripts development by the 
[Bento](https://github.com/opscode/bento) project. Bento supports a comprehensive range of operating systems and 
providers, creating vanilla, minimal images.

This project uses these templates and scripts as a stable foundation on which some elements are removed and others 
added in the form of [Customisations](#customisations).

### Provisioning/Post-processing scripts

The scripts used for provisioning and post-provisioning are organised in the following structure:

* `provisioning/scripts/` - all scripts
    * `common/` - scripts relevant to all distributions and providers
        * `common/` - scripts relevant to all distributions and providers
        * `[provider type]/` - scripts relevant to a specific type of provider (e.g. `desktop`)
    * `[distribution]/` - scripts relevant to a specific operating system (e.g. `scripts/centos`)
        * `[distribution]/{common|[environment]}/` - e.g. `scripts/centos/desktop`

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
