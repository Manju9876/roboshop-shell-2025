dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
#some file need to be created
systemctl enable nginx
systemctl start nginx
systemctl status nginx