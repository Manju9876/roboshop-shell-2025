source common.sh

echo -e "\e[31m>>>>>>>>>>>>> Disable nodejs <<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y

echo -e "\e[31m>>>>>>>>>>>>> Enable nodejs version 20 <<<<<<<<<<<<\e[0m"
dnf module enable nodejs:20 -y

echo -e "\e[31m>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[31m>>>>>>>>>>>>> create user <<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m>>>>>>>>>>>>> Create a directory <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>> Download application code <<<<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip

echo -e "\e[31m>>>>>>>>>>>>> Copy systemd file <<<<<<<<<<<<\e[0m"
cp /home/ec2-user/roboshop-shell-2025/cart.service /etc/systemd/system/cart.service

echo -e "\e[31m>>>>>>>>>>>>> unzip application code in /app <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/cart.zip

echo -e "\e[31m>>>>>>>>>>>>> install dependencies  <<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>>>>>>>>>>>> Daemon reload <<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[31m>>>>>>>>>>>>>enable and restart cart service <<<<<<<<<<<<\e[0m"
systemctl enable cart
systemctl restart cart