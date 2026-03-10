terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
 }

resource "aws_security_group" "web_sg" {
  name        = "devops-web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # later: restrict to your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2-key"
  public_key = file("${path.module}/ec2-key.pub")
}

resource "aws_instance" "s1" {
  ami                    = "ami-02dfbd4ff395f2a1b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.deployer.key_name

user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "server1"
  }
}

output "public_ip" {
  value = aws_instance.s1.public_ip
}

