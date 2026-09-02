#Create EBS Volume Using Terraform

resource "aws_ebs_volume" "first_ebs" {
  availability_zone = "ap-south-2a"
  size = 2
  type="gp3"
  tags={
    Name="Demo-volume-terraform"
  }
}