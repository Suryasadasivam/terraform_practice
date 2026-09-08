#Create EBS Volume Using Terraform

resource "aws_ebs_volume" "first_ebs" {
  availability_zone = "ap-south-2a"
  size = 2
  type="gp3"
  tags={
    Name="Demo-volume-terraform"
  }
}

resource "aws_ebs_volume" "second_ebs" {
  availability_zone = "ap-south-2a"
  size = 100
  type="gp3"
  tags={
    Name="demo2-volume"
  }
}

# Create the snapshot for above volume 
resource "aws_ebs_snapshot" "xfusion_vol_ss" {
  volume_id  = aws_ebs_volume.second_ebs.id
  description = "Xfusion Snapshot"

  tags = {
    Name = "xfusion-vol-ss"
  }
}

# Create EC2 instance for monitoring
resource "aws_instance" "datacenter_ec2" {
  ami           = "ami-12345678"   # Placeholder AMI for LocalStack/testing
  instance_type = "t2.micro"
  
  tags = {
    Name = "datacenter-ec2"
  }
}

# Create CloudWatch alarm for CPU monitoring
resource "aws_cloudwatch_metric_alarm" "datacenter_alarm" {
  alarm_name          = "datacenter-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU utilization exceeds 80%."
  actions_enabled     = false  # Disable actions since SNS may not be configured
  
  dimensions = {
    InstanceId = aws_instance.datacenter_ec2.id
  }
}