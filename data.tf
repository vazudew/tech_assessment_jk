# -------------------------------
# get default vpc 
# -------------------------------
data "aws_vpc" "default" {
  default = true
}

# -------------------------------
#  get  public subnets, we have tagged it with function = dev 
# -------------------------------
data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
filter {
  name   = "tag:function"
  values = ["*dev*"]
  }
}

# -------------------------------
#  Data source to find the latest Ubuntu 24.04 LTS AMI 
# -------------------------------
data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]   # Canonical (official Ubuntu owner ID)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251022"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -------------------------------
# Fetch an existing IAM role by name
# -------------------------------
data "aws_iam_role" "ssm_role" {
  name = "ec2_role_for_ssm_access"  
}

# -------------------------------
# Fetch SSM Document to execute Shellscript
# -------------------------------
data "aws_ssm_document" "get_file" {
  name = "AWS-RunShellScript"
}