# BAS Base Images

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased][unreleased]

### Removed [BRAKING!]

* Vagrant insecure key removed from desktop providers of the `antarctica-centos7` image
* Passwordless sudo removed from all providers of the `antarctica-centos7` image
* `wget` removed as a default package in desktop providers of the `antarctica-centos7` image

### Changed [BREAKING!]

* Updating `antarctica-centos7` image to CentOS 7.8 as CentOS 7.5 is no longer available
* Switching from CentOS 'full' installation ISO to 'minimal' ISO
* The root account is now locked in desktop providers of the `antarctica-centos7` image
* The system firewall (with SSH enabled) is now enabled in desktop providers of the `antarctica-centos7` image

### Added

* Cloud-init with the VMware guest information provider added to desktop providers of the `antarctica-centos7` image

### Fixed

* Correctly disabling SE Linux in the `antarctica-centos7` Digital Ocean image
* Update template and provisioning scripts to remove 'artefact' and 'artefact_alt' identifiers in favour of a single 
  'template' identifier
* Pinning Packer version in CI

### Changed

* Pinning Packer Docker image version to prevent issues with regressions added in the latest releases
* Removing customisation of CPU count and memory size VMX options in `vmware-iso` builder due to Packer warning these
  shouldn't be overridden

## 0.1.0 (2018-09-01)

### Added

* GitLab CI pipeline to validate Packer definitions
* Restarting project with a customised version of the Bento CentOS 7 desktop image
