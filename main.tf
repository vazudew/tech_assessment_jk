# -------------------------------
# create security group for the ec2 jenkins server
# -------------------------------
resource "aws_security_group" "allow_jenkins_port_sg" {
  name        = "allow-tcp-${var.jenkins_port}"
  description = "Allow inbound TCP ${var.jenkins_port} from anywhere, all outbound"
  vpc_id      =  data.aws_vpc.default.id

  ingress {
    description = "Allow TCP ${var.jenkins_port} from anywhere"
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# -------------------------------
# create ec2 jenkins server
# -------------------------------
resource "aws_iam_instance_profile" "jenkins_server_iam_profile" {
  name = "jenkins_server_iam_profile"
  role =data.aws_iam_role.ssm_role.name
}

module "jenkins_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "jenkins_server"
  instance_type = "t3.micro"
  monitoring    = true
  
  subnet_id     = data.aws_subnets.default_public.ids[0]
  ami =  data.aws_ami.ubuntu_2404.id
  
  iam_instance_profile = aws_iam_instance_profile.jenkins_server_iam_profile.name
  vpc_security_group_ids = [aws_security_group.allow_jenkins_port_sg.id]
  create_security_group = false
  user_data_base64 = base64encode(file("${path.module}/jenkins_scripts/jenkins_installer.sh"))
  user_data_replace_on_change = true
  depends_on = [aws_iam_instance_profile.jenkins_server_iam_profile, aws_security_group.allow_jenkins_port_sg]
}