#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
MyIP=`curl -4 icanhazip.com`
echo "Apache WS is active. Server IP: $MyIP" > /var/www/html/index.html
sudo systemctl start apache2.service