echo -e "\e[31m>>>>>>>>>>>>> disable Node js <<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y

echo -e "\e[31m>>>>>>>>>>>>> enable Node js version 20 <<<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:20 -y

echo -e "\e[31m>>>>>>>>>>>>> Insatall Node js <<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[31m>>>>>>>>>>>>> Add roboshop user <<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>>>>>> Create a directory  <<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>> Download application code <<<<<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip

echo -e "\e[31m>>>>>>>>>>>>> copy user.service file  <<<<<<<<<<<<<<\e[0m"
cp /home/ec2-user/roboshop-shell-2025/user.service /etc/systemd/system/user.service

echo -e "\e[31m>>>>>>>>>>>>> move to /app and unzip content <<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip

echo -e "\e[31m>>>>>>>>>>>>> install Node js dependencies <<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>>>>>>>>>>>> reload service, enable and start nodejs <<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user.service
systemctl start user.service
