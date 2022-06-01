
# To use this workflow, you will need to complete the following setup steps.
#
# 1. Create a `main.tf` file in the root of this repository with the `remote` backend and one or more resources defined.
 # Example `main.tf`:
#     # The configuration for the `remote` backend.
#     terraform {
#       backend "remote" {
#         # The name of your Terraform Cloud organization.
#         organization = "example-org-eca7ff"

#         # The name of the Terraform Cloud workspace to store Terraform state files in.
#         workspaces {
#           name = "devops-01-final-TeamC-Scenario-02"
#         }
#       }
#     }

    terraform {
      cloud {
        organization = "example-org-eca7ff"

        workspaces {
          name = "final-project-teamC"
        }
      }
    }


    # An example resource that does nothing.
    resource "null_resource" "example" {
      triggers = {
        value = "A example resource that does nothing!"
      }
    }
