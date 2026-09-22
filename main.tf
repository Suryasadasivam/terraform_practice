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


#Create Public S3 Bucket Using Terraform
resource "aws_s3_bucket" "x_fusion" {
  bucket = "xfusion-s3-187261992"

  tags = {
    Name        = "xfusion-s3-187261992"
  }
}

resource "aws_s3_bucket_acl" "example" {

  bucket = aws_s3_bucket.x_fusion.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.x_fusion.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Create private S3 bucket for secure data storage
resource "aws_s3_bucket" "nautilus_bucket" {
  bucket = "nautilus-s3-15729"
}

# Block all public access to ensure private bucket
resource "aws_s3_bucket_public_access_block" "nautilus_block" {
  bucket = aws_s3_bucket.nautilus_bucket.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create IAM user for identity and access management
resource "aws_iam_user" "iamuser_john" {
  name = "iamuser_john"
}

# Create IAM group for identity and access management
resource "aws_iam_group" "developers" {
  name = "developers"
}

# Create IAM policy for EC2 read-only access
resource "aws_iam_policy" "iampolicy_yousuf" {
  name        = "iampolicy_yousuf"
  description = "Read-only access to EC2 console (instances, AMIs, and snapshots)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      }
    ]
  })
}


# Create DynamoDB table for storing user data
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "xfusion-users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "xfusion_id"


  attribute {
    name = "xfusion_id"
    type = "S"
  }
}
#Create AWS Kinesis Data Stream
resource "aws_kinesis_stream" "devops_stream" {
  name             = "devops-stream"
  shard_count      = 1
}

# Create SNS topic for sending notifications
resource "aws_sns_topic" "datacenter_notifications" {
  name = "datacenter-notifications"
}