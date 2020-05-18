# BAS Base Images

A subset of customised [Packer](http://www.packer.io/) templates from [Bento](https://github.com/opscode/bento) for
creating virtual machine base images for use at BAS using [cloud-init](https://cloudinit.readthedocs.io/en/18.5/).

## Supported distributions

Each supported distribution is defined by a Packer template. It describes how to create artefacts for each
[Supported provider](#supported-providers).

Artefacts for a template are versioned using [Calender versioning](https://calver.org/overview.html) to indicate when it
was created and the [Customisations](#customisations) it includes.

| Template                                  | Distribution | Version | Architecture | Current Artefact Version |
| ----------------------------------------- | ------------ | ------- | ------------ | ------------------------ |
| [antarctica-centos7](#antarctica-centos7) | CentOS       | 7.8     | x86_64       | *2020-05-18*             |

### antarctica-centos7

The default distribution used at BAS: [Packer template](/packer/templates/antarctica-centos7.json).

A set of default [Customisations](#customisations) are applied to a minimal CentOS server install using a
[Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations)
[configuration file](/packer/provisioning/preseed/antarctica-centos7/ks.cfg).

#### System changes

Some, system level changes, have occurred between template artefact versions. These are not customisations and may cause
breaking changes. They should be reviewed prior to switching versions.

##### Between `2018-08-10` and `2018-10-08`

* no changes

##### Between `2018-10-08` and `2020-05-18`

* CentOS 7.5 upgraded to 7.8 (7.5 is no longer available)
* CentOS installation ISO changed from 'full' to 'minimal' (this may require you to explicitly install packages you didn't previously)

#### Customisations

Various, BAS specific, customisations are applied when building template artefacts. Customisations are used for
localisation or local practice and for usability, workflow and convenience.

The table below lists which customisations apply to which template versions and why they've been applied.

| Customisation                        | Since Version | Until Version | Category | Rational                                                          |
| ------------------------------------ | ------------- | ------------- | -------- | ----------------------------------------------------------------- |
| Swap file removed                    | *2018-08-10*  | -             | System   | Swap will be recreated for each instance if needed                |
| Network interfaces removed           | *2018-08-10*  | -             | System   | From Bento project                                                |
| SELinux disabled                     | *2018-08-10*  | -             | Security | BAS convention, see [Security](#security)                         |
| Firewall disabled                    | *2018-08-10*  | *2020-05-18*  | Security | BAS convention, see [Security](#security)                         |
| `UseDNS` set to `no`                 | *2018-08-10*  | -             | SSH      | From Bento project                                                |
| `GSSAPIAuthentication` set to `no`   | *2018-08-10*  | -             | SSH      | From Bento project                                                |
| Host keys removed                    | *2018-08-10*  | -             | SSH      | Keys will be recreated for each instance                          |
| Passwordless sudo enabled            | *2018-08-10*  | *2020-05-18*  | Sudo     | To allow for automated provisioning                               |
| SSH Agent allowed using Sudo         | *2018-08-10*  | -             | Sudo     | To allow connecting through other hosts using private keys        |
| Language set to `en_GB_UTF-8`        | *2018-08-10*  | -             | Locale   | Regional default                                                  |
| Keyboard layout set to `uk`          | *2018-08-10*  | -             | Locale   | Regional default                                                  |
| Timezone set to `UTC`                | *2018-08-10*  | -             | Locale   | Regional default and BAS convention                               |
| Root user password                   | *2018-08-10*  | *2020-05-18*  | Users    | To allow for automated provisioning, see [Security](#security)    |
| Root user authorized key             | *2018-08-10*  | *2020-05-18*  | Users    | To allow for automated provisioning, see [Security](#security)    |
| Yum upgrade                          | *2018-08-10*  | -             | Packages | To update all OS packages to latest versions                      |
| Yum clean                            | *2018-08-10*  | -             | Packages | To reduce size of artefacts removing unnecessary files and caches |
| `sudo` packages installed            | *2018-08-10*  | -             | Usage    | To allow for automated provisioning, see [Usage](#usage)          |
| `wget` packages installed            | *2018-08-10*  | *2020-05-18*  | Packages | Required for installation                                         |
| Ansible facts                        | *2018-08-10*  | -             | Usage    | For automated provisioning, see [Ansible facts](#ansible-facts)   |
| SELinux (properly) disabled          | *2018-08-10*  | -             | Security | Fixing a bug in previous version                                  |
| Root account locked                  | *2020-05-18*  | -             | Security | For security (use sudo to perform privileged actions)             |
| System firewall enabled (with SSH)   | *2020-05-18*  | -             | Security | For security (SSH is allowed for automated provisioning)          |
| cloud-init support added             | *2020-05-18*  | -             | Usage    | To allow for automated provisioning, see [Usage](#usage)          |
| VMware cloud-init provider added     | *2020-05-18*  | -             | Usage    | To allow for automated provisioning, see [Usage](#usage)          |
| EPEL Yum repository added            | *2020-05-18*  | -             | Packages | Required to install `python-pip` package                          |
| `open-vm-tools` package installed    | *2020-05-18*  | -             | Packages | Required by VMware cloud-init provider                            |
| `python-pip` package installed       | *2020-05-18*  | -             | Packages | Required by VMware cloud-init provider                            |
| `deepmerge` Python package installed | *2020-05-18*  | -             | Packages | Required by VMware cloud-init provider                            |
| `netifaces` Python package installed | *2020-05-18*  | -             | Packages | Required by VMware cloud-init provider                            |

#### Artefact Checksums

| Artefact Version | SHA 256 Checksum                                                   |
| ---------------- | ------------------------------------------------------------------ |
| `2018-08-10`     | `5ec748ca961f021e6f7f8e8c383d9df1d2ad7796a254fe6001e31e49271ec089` |
| `2020-05-18`     | `71ab7a22bb8df428840de78ac99f20a815e6d4d8f64279c0956aeae6cced4d9b` |

#### Artefact downloads

Artefacts for desktop providers can be downloaded from the BAS Repo Server:

http://bsl-repoa.nerc-bas.ac.uk/magic/v1/projects/bas-base-images/artefacts/antarctica-centos7

## Supported providers

| Provider     | Type    | Artefact Type                                                        | Packer Builder |
| ------------ | ------- | -------------------------------------------------------------------- | -------------- |
| VMware ESXi  | Desktop | [OVA](https://en.wikipedia.org/wiki/Open_Virtualization_Format) file | `vmware-iso`   |
| DigitalOcean | Cloud   | [DigitalOcean Image](https://www.digitalocean.com/docs/images/)      | `digitalocean` |

## Security

You **MUST** ensure that a appropriate level of security is in place for any data stored in, and services ran on, any
use of these templates. If in doubt contact [BAS IT](mailto:servicedesk@bas.ac.uk) for advice.

### SE Linux

By convention, SELinux is disabled on VMs running in BAS Cambridge. This project follows this conventions, however this
may present a security risk in cloud providers.

### System firewall

From `antarctica-centos7`, version `2020-05-18`, the system firewall is enabled, with SSH (on port 22) allowed.
Additional rules will need to be added using cloud-init or onward provisioning to allow other services, such as HTTP(S).

**WARNING!** Prior to `antarctica-centos7`, version `2020-05-18`, the system firewall is disabled by default, which may
present a security risk in cloud providers.

### Root user

From `antarctica-centos7`, version `2020-05-18`, the root user account is locked and cannot be used. Instead cloud-init
must be used to configure additional user accounts with suitable sudo permissions to perform privileged actions. See the
[Usage](#usage) section for more information.

**WARNING!** Prior to `antarctica-centos7`, version `2020-05-18`, the root account was intentionally configured with the
insecure defaults below, as accounts could not be created securely ahead of time in a a generic template.

| Credential  | Value                                                                                         |
| ----------- | --------------------------------------------------------------------------------------------- |
| Username    | `root`                                                                                        |
| Password    | `password`                                                                                    |
| Private key | [Vagrant insecure private key](https://github.com/hashicorp/vagrant/blob/master/keys/vagrant) |

## Usage

### Overview

From `antarctica-centos7`, version `2020-05-18`, the recommend way to use this base image is with
[Terraform](https://www.terraform.io) and [cloud-init](https://cloudinit.readthedocs.io/en/18.5/). This allows you to
automate creating, and initially configuring, one or more virtual machines using a [Supported distribution](#supported-distribution) with a [Supported provider](#supported-provider).

**Note:** Terraform is not required to use base images from this project, you can use VMware's or DigitalOcean's online
consoles instead, however Terraform is useful for creating related infrastructure such as DNS records and for managing
the state of your infrastructure in an automated way.

At a very high level: Terraform treats VMs as generic boxes of different colours and sizes (distributions and resources)
that are organised and linked to each other (folders/workspaces and networking). Cloud-init focuses on the contents of
each box, such as it's name, who is allowed to access it and what's inside it.

### Suggested workflow

A suggested workflow for creating one or VMs using this approach is:

1. define the VMs as resources in Terraform (e.g. x2 web servers)
2. create a cloud-init configuration defining initial user accounts and allowed public keys (or reuse a team default)
3. Terraform creates the required VMs using artefacts from this project
4. On first boot, cloud-init runs to create required users listed in the configuration file
5. onward provisioning is then ran to setup VMs for their purpose (e.g. deploying and configuring an application)

**Note:** Cloud-init is a powerful tool, that could feasibly perform provisioning typically performed by tools such as
Ansible, however in this suggested workflow it is limited to setting up the accounts that tools such as Ansible will
use for provisioning. Ansible (or related tools) are recommended because they are designed to be ran more than once in a
VM's lifecycle and offer more powerful primitives for configuring hosts in a coordinated way (cloud-init is inherently
focused on a single VM).

### BAS development cluster

The Development Cluster is a cluster within in the Cambridge data centre in the BAS vCentre (vSphere) infrastructure.
It consists of team based resource pools, a development network (*10.70.x.x*) and development storage cluster.

You will need permissions to create VMs in one or development cluster resource pools to use this provider. Contact
[BAS IT](mailto:servicedesk@bas.ac.uk) if you do not currently have access.

Virtual machines are created by cloning a template (built from an artefact from this project) using the
[`vsphere](https://www.terraform.io/docs/providers/vsphere/index.html) Terraform provider. A
[cloud-init datasource](https://github.com/vmware/cloud-init-vmware-guestinfo) for VMware vSphere's GuestInfo interface
is used to pass a cloud-init configuration from the VM definition through to cloud-init.

See [usage/examples/terraform/bas-development-cluster](/usage/examples/terraform/bas-development-cluster) for usage examples.

You can also use the [vCentre console](https://bsv-vcsa-s1.nerc-bas.ac.uk/ui/) to view and manage VMs manually if needed [1].

[1] The BAS vCentre instance currently uses a self-signed TLS certificate.

### DigitalOcean

See the [BAS DigitalOcean](https://gitlab.data.bas.ac.uk/WSF/bas-do) project for how to provision resources using
artefacts from this project.

### Ansible facts

To aid in onward provisioning, information the template and template version used to create a VM is made available as
[Ansible facts](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html#information-discovered-from-systems-facts).

For example, a task:

```yaml
- name: report facts about base image
  hosts: host
  tasks:
    - debug:
        msg: "{{ ansible_local.os_template.general }}"
```

Will return output similar to:

```
ok: [host] => {
    "msg": {
        "name": "antarctica-centos7",
        "version": "2018-08-10"
    }
}
```

## Setup

To build artefacts for each provider defined in a Packer template:

```shell
$ packer build packer/templates/[template].json
# E.g.
$ packer build packer/templates/antarctica-centos7.json
```

**Note:** You will need the software or permissions required by each [Packer builder](#supported-providers).

Artefacts will be created in parallel, applying any relevant [Customisations](#customisations) ready for
[Deployment](#deployment).

If needed, builds can be limited to a single provider:

```
$ packer build --only=[provider] packer/templates/[template].json
# E.g.
$ packer build --only=digitalocean packer/templates/antarctica-centos7.json
```

For providers which produce artefacts as files, a SHA 256 checksum will be generated. Add this value to the templates'
artefact checksums section.

**Note:** It will take longer the first time you build a template, as Packer needs to download the installation ISOs for
desktop providers.

### Terraform outputs

A set of Terraform outputs are used to define identifiers for some provider artefacts. These are intended for users of
these artefacts to give default values.

**Note:** default identifiers for other providers are defined in other projects, along with provider specific examples.

When a new artefact is made, update the corresponding output in
[provisioning/terraform/06-outputs.tf](/provisioning/terraform/06-outputs.tf) and update the remote state.

As outputs are not tracked as resources or data sources they do not affect state. To workaround this, a null resource is
used which acts as a dummy resource that is tracked and so will included in state, along with outputs.

Therefore when updating outputs, the null provider needs to be destroyed and recreated to update the output in remote
state.

**Note:** You will need access to update [Terraform remote state](#terraform-remote-state).

```
$ cd provisioning/terraform
$ docker-compose run terraform
$ terraform init
$ terraform validate
$ terraform fmt
$ terraform destroy
$ terraform apply
```

### Terraform remote state

State information for this project is stored remotely using a
[Backend](https://www.terraform.io/docs/backends/index.html).

Specifically the [AWS S3](https://www.terraform.io/docs/backends/types/s3.html) backend as part of the
[BAS Terraform Remote State](https://gitlab.data.bas.ac.uk/WSF/terraform-remote-state) project.

Remote state storage will be automatically initialised when running `terraform init`. Any changes to remote state will
be automatically saved to the remote backend, there is no need to push or pull changes.

#### Remote state authentication

Permission to read and/or write remote state information for this project is restricted to authorised users. Contact
the [BAS Web & Applications Team](mailto:servicedesk@bas.ac.uk) to request access.

See the [BAS Terraform Remote State](https://gitlab.data.bas.ac.uk/WSF/terraform-remote-state) project for how these
permissions to remote state are enforced.

### Accessing remote state

To use outputs from this project in other projects use a [Terraform remote state](https://www.terraform.io/docs/providers/terraform/index.html) data source as below.

```
data "terraform_remote_state" "BAS-BASE-IMAGES" {
    backend = "s3"
    config {
        bucket = "bas-terraform-remote-state-prod"
        key = "v2/BAS-BASE-IMAGES/terraform.tfstate"
        region = "eu-west-1"
    }
}
```

See [usage/examples/terraform/bas-development-cluster](/usage/examples/terraform/bas-development-cluster) and other examples for usage examples.

## Deployment

Artefacts for desktop [Providers](#supported-providers) are built locally and need deploying before they can be used.

### vCentre

OVA artefacts need to be deployed as a virtual machine that is then converted into a template.

**Note:** This is manual due to [WSF/bas-base-images#12](https://gitlab.data.bas.ac.uk/WSF/bas-base-images/issues/12).

To create a virtual machine from an OVF/OVA file:

1. login to the [BAS vCentre instance](https://bsv-vcsa-s1.nerc-bas.ac.uk/ui/) with your NERC AD credentials [1] [2]
2. navigate to the relevant resource pool
3. from *ACTIONS* choose *Deploy OVF template*
4. choose to upload a local file and select the *OVA* file from the local artefacts directory
5. name the virtual machine in the form `base-[template]-[template-version]` e.g. `base-antarctica-centos7-2001-01-20`)
6. choose a suitable location (you will likely not have permission to deploy directly to the cluster)
7. choose a compute resource (this is almost always the same as the location)
8. VMware will check the template and display it's details (it will warn about it using advanced features, this is fine)
9. set the virtual disk format to *Thin Provision* and select a suitable data store
10. review the details and finish

vCentre will now upload and create a Virtual Machine from the OVA image, this will take some time. Once complete:

1. select the new virtual machine, from *ACTIONS* choose *Edit settings*:
    * remove the CD-ROM device
    * choose *ADD NEW DEVICE* -> *Network Adapter* and browse for the `DEV Network` network
2. upgrade the VM compatibility to the highest/newest available
3. convert a virtual machine into a template, from *ACTIONS* choose *Template* -> *Convert to Template*
    * confirm the warning
    * from the left navigation, switch to the second view (*VMs and Templates*), the template should be visible

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

* `packer/provisioning/scripts/` - all scripts
    * `common/` - scripts relevant to all distributions and providers
        * `common/` - scripts relevant to all distributions and providers
        * `[provider type]/` - scripts relevant to a specific type of provider (e.g. `desktop`)
    * `[distribution]/` - scripts relevant to a specific operating system (e.g. `scripts/centos`)
        * `[distribution]/{common|[environment]}/` - e.g. `scripts/centos/desktop`

Most scripts are copies, or adapted from, scripts used in the [Bento](https://github.com/opscode/bento) project. The
source of each script, or sections of a script, should indicate where it has come from (i.e. 'Bento' or 'Custom'). The
effects of any custom elements should be documented in the [Customisations](#customisations) section.

Scripts use the Bash interpreter with this `#!/usr/bin/env bash -eux` shebang to ensure compatibility across different
operating systems. The options are:

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

© UK Research and Innovation (UKRI), 2018 - 2020, British Antarctic Survey.

You may use and re-use this software and associated documentation files free of charge in any format or medium, under
the terms of the Open Government Licence v3.0.

You may obtain a copy of the Open Government Licence at http://www.nationalarchives.gov.uk/doc/open-government-licence/

This project includes material from the Chef Bento project, https://github.com/chef/bento, copyright Chef Software Inc.
See project [License](LICENSE.md) for more information.
