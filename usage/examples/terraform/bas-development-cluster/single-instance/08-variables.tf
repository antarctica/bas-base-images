#
# This file is used to define information required by other Terraform resources

# Values in this file are typically set using a Terraform variables file, `terraform.tfvars`.
# See `terraform.example.tfvars` for an example that can be copied to create one.

# These resources are defined as complete examples designed for use in other projects

# vSphere data centre
#
# Name of a (the) data centre
#
# This is effectively the root resource in a vSphere installation
variable "datacentre" {
  default = "datacentre1"
}

# vSphere network
#
# Name of a network
#
variable "network" {
  default = "network1"
}

# vSphere datastore cluster
#
# Name of a datastore cluster
#
variable "storage-cluster" {
  default = "storage1"
}

# vSphere compute cluster
#
# Name of a compute cluster
#
# This is usually the environment within a datacentre (e.g. production, development, etc.)
variable "compute-cluster" {
  default = "cluster1"
}

# vSphere resource pool
#
# Name of a resource pool
#
# This may be project, team and/or environment specific (e.g. project-x-teating, etc.)
variable "resource-pool" {
  default = "resource1"
}

