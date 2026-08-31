# output "vpc_id" {
#     value = aws_vpc.shared_vpc.id
  
# }

# output "vpc_name" {
#     value = aws_vpc.shared_vpc.tags["Name"]
  
# }

# output "subnet_id"{
#     value=aws_subnet.shared_subnet.id
# }

# output "subnet_name"{
#     value=aws_subnet.shared_subnet.tags["Name"]
# }

output "instance_id" {
  value = aws_instance.ec2_main.id
}