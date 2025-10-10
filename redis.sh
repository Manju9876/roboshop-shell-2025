dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y
#need to edit conf file
systemctl enable redis
systemctl start redis