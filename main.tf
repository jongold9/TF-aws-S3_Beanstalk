# Define the AWS provider
provider "aws" {
  region     = var.aws_region # Replace with your region, for example "eu-central-1"
  access_key = var.aws_access_key # Your AWS access key
  secret_key = var.aws_secret_key # Your AWS secret key
}

# Get information about an existing IAM role
data "aws_iam_role" "existing_beanstalk_ec2_role" {
  name = "benastalkEC2-role" # Name of your existing IAM role
}

# Create an IAM instance profile for EC2
resource "aws_iam_instance_profile" "benastalkEC2" {
  name = "benastalkEC2-instance-profile"
  role = data.aws_iam_role.existing_beanstalk_ec2_role.name
}

# Create an Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "myflask4" {
  name = "MyFlask4" # Name of your application
}

# Create an Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "myflask4_env" {
  name                = "MyFlask4-env" # Name of your environment
  application         = aws_elastic_beanstalk_application.myflask4.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.9 running Python 3.11" # Actual solution stack name, verify its actuality!

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.benastalkEC2.name
  }

  # Additional settings according to your configuration
}

# Create an S3 bucket
resource "aws_s3_bucket" "myip-flask-application-packages" {
  bucket = "myip-flask-application-packages"
  acl    = "private"  # Configure ACL according to your requirements
}

# Output the Elastic Beanstalk environment URL
output "beanstalk4_url" {
  value = aws_elastic_beanstalk_environment.myflask4_env.endpoint_url
}
