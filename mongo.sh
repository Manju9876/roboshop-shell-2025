echo -e "\e[31m>>>>>>>>>>>>>>>> Copy repo file <<<<<<<<<<<<<<<<<<"
cp /home/ec2-user/roboshop-shell-2025/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>>>>>>>>>> install mongod <<<<<<<<<<<<<<<<<<"
dnf install mongodb-org -y

echo -e "\e[31m>>>>>>>>>>>>>>>> Enable and start mongod <<<<<<<<<<<<<<<<<<"
systemctl enable mongod
systemctl restart  mongod

echo -e "\e[31m>>>>>>>>>>>>>>>> Edit and set 12.0.0.0 to 0.0.0.0 <<<<<<<<<<<<<<<<<<"
sed  -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[31m>>>>>>>>>>>>>>>> Restart mongod <<<<<<<<<<<<<<<<<<"
systemctl restart mongod

