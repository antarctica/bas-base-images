#
# This file is used to define Terraform remote state resources

# These resources import the remote state of another project, typically for using their outputs

# These resources are defined as complete examples designed for use in other projects

# The BAS-BASE-IMAGES remote state
#
# Includes outputs such as preferred templates.
#
# This configuration is protected and requires AWS access credentials for the BAS Terraform Remote State project
# See https://gitlab.data.bas.ac.uk/WSF/terraform-remote-state for details
#
# Source: https://gitlab.data.bas.ac.uk/WSF/bas-base-images
# Terraform source: https://www.terraform.io/docs/providers/terraform/r/remote_state.html
data "terraform_remote_state" "BAS-BASE-IMAGES" {
  backend = "s3"
  config = {
    bucket = "bas-terraform-remote-state-prod"
    key    = "v2/BAS-BASE-IMAGES/terraform.tfstate"
    region = "eu-west-1"
  }
}
