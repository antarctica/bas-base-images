#
# This file is used to refer to external resources that Terraform does not manage but are required by managed resources

# These resources are defined as complete examples designed for use in other projects

# Datacentre
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/d/datacenter.html
data "vsphere_datacenter" "dc" {
  name = var.datacentre
}

# Network
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/d/network.html
data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Storage cluster
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/d/datastore_cluster.html
data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = var.storage-cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Compute cluster
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/d/compute_cluster.html
data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.compute-cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Resource pool
#
# Resource pool names have a specific structure:
# `/[datacentre]/host/[compute cluster]/Resources/[resource pool]
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/d/resource_pool.html
# Additional source: https://github.com/hashicorp/terraform/issues/16373#issuecomment-416296528
data "vsphere_resource_pool" "pool" {
  name          = "/${data.vsphere_datacenter.dc.name}/host/${data.vsphere_compute_cluster.compute_cluster.name}/Resources/${var.resource-pool}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# VM template
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/d/virtual_machine.html
data "vsphere_virtual_machine" "template" {
  name          = data.terraform_remote_state.BAS-BASE-IMAGES.outputs.BAS-BASE-IMAGE-ANTARCTICA-CENTOS7-VMWARE-TEMPLATE-VM
  datacenter_id = data.vsphere_datacenter.dc.id
}
