#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to the final project! My private IP is $myip <font color="green"> in ${env} environment</font></h1><br>Group06: <br>Rashmeek <br>Nobel <br>Simran <br>Bari" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd