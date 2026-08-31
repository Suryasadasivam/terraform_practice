terraform{
    backend "s3" {
        bucket="terraform-state-file-surya"
        key="dev/terraform.tfstate"
        region = "ap-south-2"
        use_lockfile = true
        encrypt = true
        }
    required_providers {
      aws={
        source = "hashicorp/aws",
        version = "~> 6.0"
      }
    }

}

provider "aws" {
    region="ap-south-2"
  
}

# resource "aws_vpc" "shared_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags={
#     Name= "shared_vpc_for_ec2"
#   }
# }

# resource "aws_subnet" "shared_subnet"{
#     vpc_id = aws_vpc.shared_vpc.id
#     cidr_block = "10.0.1.0/24"
#     tags={
#         Name="shared_subnet_for_ec2"
#     }
# }


data "aws_vpc" "shared" {
    filter {
        name="tag:Name"
        values= ["shared_vpc_for_ec2"]
    }
}

data "aws_subnet" "shared_subnet"{
    filter {
      name = "tag:Name"
      values= ["shared_subnet_for_ec2"]
    }
    vpc_id = data.aws_vpc.shared.id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_main"{
    ami = data.aws_ami.amazon_linux_2.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.shared_subnet.id
    tags = {
      Name="ec2_from_terraform"
    }
}