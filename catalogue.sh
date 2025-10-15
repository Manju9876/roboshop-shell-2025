#script_path=(dirname $0)
#source ${script_path}/common.sh
echo $0
basename $0
dirname $0
pwd
exit

echo -e "\e[31m>>>>>>>>>>>>> disable Node js <<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y

echo -e "\e[31m>>>>>>>>>>>>> enable Node js version 20 <<<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:20 -y

echo -e "\e[31m>>>>>>>>>>>>> install Node js <<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[31m>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m>>>>>>>>>>>>> create a directory <<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>> download application code <<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip

#echo -e "\e[31m>>>>>>>>>>>>> copy catalogue service to systemd <<<<<<<<<<<<<<\e[0m"
#cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m>>>>>>>>>>>>> unzip application code <<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[31m>>>>>>>>>>>>> install Node js dependencies <<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>>>>>>>>>>>> copy catalogue service to systemd <<<<<<<<<<<<<<\e[0m"
cp /home/ec2-user/roboshop-shell-2025/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m>>>>>>>>>>>>> reload and start catalogue service  <<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[31m>>>>>>>>>>>>> copy mongod repo from mongo.repo <<<<<<<<<<<<<<\e[0m"
cp /home/ec2-user/roboshop-shell-2025/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>>>>>>> install mongodb <<<<<<<<<<<<<<\e[0m"
dnf install mongodb-mongosh -y

echo -e "\e[31m>>>>>>>>>>>>> connect to schema <<<<<<<<<<<<<<\e[0m"
mongosh --host mongodb-dev.devopsbymanju.shop </app/db/master-data.js
