#
# This file is used to define resources attributes as outputs for use in other projects via remote state

# To use these outputs in other projects a 'terraform_remote_state' resource is needed, as shown in
# '/usage/examples/terraform/bas-development-cluster/single-instance/04-remote_state.tf' and other examples

# Template identifiers - for use with VMware VM

output "BAS-BASE-IMAGE-ANTARCTICA-CENTOS7-VMWARE-TEMPLATE-VM" {
  value = "base-antarctica-centos7-2020-05-18"
}
