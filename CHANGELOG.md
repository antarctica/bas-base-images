# BAS Base Images

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased][unreleased]

### Fixed

* Update template and provisioning scripts to remove 'artefact' and 'artefact_alt' identifiers in favour of a single 
  'template' identifier

### Changed

* Pinning Packer Docker image version to prevent issues with regressions added in the latest releases

## 0.1.0 (2018-09-01)

### Added

* GitLab CI pipeline to validate Packer definitions
* Restarting project with a customised version of the Bento CentOS 7 desktop image
