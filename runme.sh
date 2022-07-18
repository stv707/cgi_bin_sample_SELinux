#!/bin/bash
HO=serverb.example.local
HOSTNAME=$(hostname)
if [ $HOSTNAME != $HO ]
then
 echo "RUN IN serverb.example.local"
 exit 22
fi
SE=$(getenforce)
if [ $SE == 'Enforcing' ]
then
 echo "Disable SElinux and Reboot and rerun this"
 echo -e "We can do for you [ ]\b\b\c"
 read ANS
  if [ $ANS == "y" ]
  then
  sed -i 's/^ *SELINUX *= *enforcing.*/SELINUX=disabled/'  /etc/selinux/config
  echo "Please reboot and rerun this script"
  exit 87
  else
  exit 55
  fi
fi
systemctl status httpd &> /dev/null
if [ $? -ne 0 ]
then
 yum install httpd -y
 if [ -f /etc/httpd/conf/httpd.conf ]
 then
  sed -i 's:/var/www/html:/data/www/html:' /etc/httpd/conf/httpd.conf
  sed -i 's/Listen *80/Listen 4242/' /etc/httpd/conf/httpd.conf
  mkdir -p /data/www/html
  if [ -f speed.html ]
  then
  cp speed.html /data/www/html/
  else
  echo "file speed.html not found"
  exit 33
  fi
  if [ -f speed.py ]
  then
   cp speed.py  /var/www/cgi-bin/
  else
  echo "file speed.py not found"
  exit 33
  fi
  chmod a+x /var/www/cgi-bin/speed.py
  firewall-cmd --add-port=4242/tcp --permanent
  firewall-cmd --reload

  systemctl enable --now httpd
  fi
else
 echo "httpd seems already installed, please remove and rerun this script"
 exit 23
fi