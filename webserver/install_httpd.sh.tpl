#!/bin/bash
yum update -y
yum install -y httpd.x86_64
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
echo "<h1>Welcome to ACS730 Final Project! This is group06. Nobelpreet, Simran, Bari, Rashmeek <font color="turquoise"> in ${env} environment</font></h1><br>Built by Terraform!"  > /var/www/html/index.html