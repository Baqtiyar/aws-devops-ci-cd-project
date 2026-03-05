#!/bin/bash

yum update -y
yum install docker -y

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

# Pull your image (use :latest explicitly)
docker pull baqtiyar/dockerflaskimage:latest

# Run container
docker run -d --name container1 -p 80:5000 baqtiyar/dockerflaskimage:latest

