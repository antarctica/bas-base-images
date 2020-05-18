#
# This file is used to define Terraform providers

# These resources are defined as complete examples designed for use in other projects

# vSphere (vCenter) provider
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/index.html
provider "vsphere" {
  # Pinned at prior to 0.16.0 due to https://github.com/terraform-providers/terraform-provider-vsphere/issues/966
  version = "< 1.16.0"

  # Set an environment variable 'VSPHERE_USER' to set your VMware (AD) username
  # e.g. VSPHERE_USER=conwat
  # Set an environment variable 'VSPHERE_PASSWORD' to set your VMware (AD) password (this isn't ideal)
  # e.g. VSPHERE_PASSWORD=password
  # Set an environment variable 'VSPHERE_SERVER' to set the VMware endpoint (this is the same as the vSphere/vCentre UI)
  # e.g. vcentre.example.com

  # The BAS vCentre instance uses a self-signed certificate
  allow_unverified_ssl = true
}
