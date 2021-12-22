resource "aws_security_group" "jenkins_server" {
  name        = "jenkins_server"
  description = "SSH and Jenkins Ports"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description = "8443 from VPC"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    description      = "Allow Internet Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-sg" }, )
}