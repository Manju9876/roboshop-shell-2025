echo -e "\e[31m>>>>>>>>>>>>>> Disable redis <<<<<<<<<<<<<<<<\e[0m"
dnf module disable redis -y

echo -e "\e[31m>>>>>>>>>>>>>> Enable redis version 7 <<<<<<<<<<<<<<<<\e[0m"
dnf module enable redis:7 -y

echo -e "\e[31m>>>>>>>>>>>>>> Install redis <<<<<<<<<<<<<<<<\e[0m"
dnf install redis -y

#need to edit conf file
systemctl enable redis
systemctl restart redis