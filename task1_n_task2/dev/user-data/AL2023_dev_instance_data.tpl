#!/bin/bash -ex
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Begin: System Update and Basic Setup"
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment
dnf update -y
echo "End: System Update and Basic Setup"

# Install pre-reqs
dnf install -y jq dos2unix wget nano git unzip

echo "Begin: Docker Installation"
dnf install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user
echo "End: Docker Installation"

echo "Begin: Install AWS CLI v2"
dnf remove awscli -y
cd /home/ec2-user/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
echo "All setup completed!"
