provider "aws" {
  
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="myvpc"
  }
}






# terraform workspace 
# Usage: terraform [global options] workspace

#   new, list, show, select and delete Terraform workspaces.

# Subcommands:
#     delete    Delete a workspace
#     list      List Workspaces
#     new       Create a new workspace
#     select    Select a workspace
#     show      Show the name of the current workspace

#  terraform workspace show
# defult

# terraform workspace nwe dev

