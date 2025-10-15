script_path=$(dirname $0)
source ${script_path}/common.sh

dirname $0
exit

echo -e "\e[31m>>>>>>>>>>>>>>> dsiable nginx <<<<<<<<<<<<<<<<\e[0m"
dnf module disable nginx -y

echo -e "\e[31m>>>>>>>>>>>>>>> Enable nginx version 1.24 <<<<<<<<<<<<<<<<\e[0m"
dnf module enable nginx:1.24 -y

echo -e "\e[31m>>>>>>>>>>>>>>> install nginx <<<<<<<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[31m>>>>>>>>>>>>>>> start nginx service  <<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx


echo -e "\e[31m>>>>>>>>>>>>>>> remove Nginx data <<<<<<<<<<<<<<<<\e[0m"
#mkdir -p /usr/share/nginx/html
rm -rf /usr/share/nginx/html/*

echo -e "\e[31m>>>>>>>>>>>>>>> Download frontend code <<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

echo -e "\e[31m>>>>>>>>>>>>>>> unzip code <<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[31m>>>>>>>>>>>>>>> copy nginx configuration file <<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/nginx.conf /etc/nginx/nginx.conf

echo -e "\e[31m>>>>>>>>>>>>>>> Restart Nginx <<<<<<<<<<<<<<<<\e[0m"
systemctl restart nginx





