#!/bin/bash

sudo yum -y update
sudo yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF >> /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by Power of Terraform <font color="red"> v1.0.3</font></h2><br><p>
<font color="green">Server Private IP: <font color="aqua">$myip<br><br>
<font color="magenta">
<b>Version 2.0</b>
</body>
</html>
EOF

sudo service httpd start
sudo chkconfig httpd on