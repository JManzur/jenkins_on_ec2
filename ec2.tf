#Grabbing latest Linux 2 AMI
data "aws_ami" "linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# EC2 Deploy
resource "aws_instance" "jenkins-ec2" {
  ami                    = data.aws_ami.linux2.id
  instance_type          = var.instance_type["type1"]
  subnet_id              = element(module.vpc.private_subnets, 0)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_server.id]

  # Jenkins instalation with Ansible Pull
  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install git -y
  amazon-linux-extras install ansible2 -y
  sleep 10
  ansible-pull -U https://github.com/JManzur/jenkins-ansible-pull
  EOF

  tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-EC2" }, )

  root_block_device {
    volume_size           = 80
    volume_type           = "gp2"
    delete_on_termination = true
    tags                  = merge(var.project-tags, { Name = "${var.resource-name-tag}-EBS" }, )
  }
}

output "jenkins_ip" {
  value = aws_instance.jenkins-ec2.private_ip
}