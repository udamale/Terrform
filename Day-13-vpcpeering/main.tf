provider "aws" {
  
}
resource "aws_vpc" "vpcA" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "vpc A"
    }
    enable_dns_hostnames = true
    enable_dns_support = true

}

resource "aws_vpc" "vpcB" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "vpc B"
    }
}

resource "aws_vpc_peering_connection" "name" {
 peer_vpc_id = aws_vpc.vpcA.id
 vpc_id = aws_vpc.vpcB.id
 auto_accept = true
 accepter {
   allow_remote_vpc_dns_resolution = true
   
 }
}

