echo -e "\e[31m>>>>>>>>>>>>>>>> install mysql <<<<<<<<<<<<<\e[0m"
dnf install mysql-server -y

echo -e "\e[31m>>>>>>>>>>>>>>>> enable and start mysql <<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[31m>>>>>>>>>>>>>>>> change default password to RoboShop@1 <<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
