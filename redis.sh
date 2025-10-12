echo -e "\e[31m>>>>>>>>>>>>>> Disable redis <<<<<<<<<<<<<<<<\e[0m"
dnf module disable redis -y

echo -e "\e[31m>>>>>>>>>>>>>> Enable redis version 7 <<<<<<<<<<<<<<<<\e[0m"
dnf module enable redis:7 -y

echo -e "\e[31m>>>>>>>>>>>>>> Install redis <<<<<<<<<<<<<<<<\e[0m"
dnf install redis -y

echo -e "\e[31m>>>>>>>>>>>>>> change localhost to 0.0.0.0 in redis.conf <<<<<<<<<<<<<<<<\e[0m"
#need to edit conf file

echo -e "\e[31m>>>>>>>>>>>>>> enable and start redis <<<<<<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis