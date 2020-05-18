#
# This file is used to define resources for compute resources

# These resources are defined as complete examples designed for use in other projects

# This example configures:
#
# * a Virtual Machine - configured with a DHCP assigned IP address and cloud-init metadata and user data

# Example VM name
#
# This name is set as a variable as it's used in multiple locations
# Under BAS conventions, all VMs should be in the form `bsl-[name]` where `bsl` assumes a Unix/Linux VM
#
# Terraform source: https://www.terraform.io/docs/configuration/locals.html
locals {
  example-name = "bsl-example"
}

# Example VM
#
# Terraform source: https://www.terraform.io/docs/providers/vsphere/r/virtual_machine.html
resource "vsphere_virtual_machine" "example" {
  name       = local.example-name
  annotation = "VM managed by Terraform and configured using cloud-init."

  folder               = "${data.vsphere_compute_cluster.compute_cluster.name}/${var.resource-pool}"
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id

  num_cpus  = 1
  memory    = 1024
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.userdata"          = base64gzip(file("70-resources/cloud-init/userdata.yml"))
    "guestinfo.userdata.encoding" = "gzip+base64"
    "guestinfo.metadata"          = base64gzip(templatefile("70-resources/cloud-init/metadata.yml.tmpl", { vm-name = local.example-name }))
    "guestinfo.metadata.encoding" = "gzip+base64"
  }
}
