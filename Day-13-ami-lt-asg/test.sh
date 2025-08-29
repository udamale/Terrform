#!/bin/bash
set -euxo pipefail

# Update the instance
yum update -y

# Install Apache HTTPD server
yum install -y httpd

# Start and enable Apache to run on boot
systemctl start httpd
systemctl enable httpd

# Create a simple landing page
echo "<html><body><h1>Your custom message here</h1></body></html>" > /var/www/html/index.html
