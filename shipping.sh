

echo -e "\e[31m>>>>>>>>>>>> Install maven <<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[31m>>>>>>>>>>>> create roboshop user <<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>>>>> create app directory <<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>> Download App code <<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip

echo -e "\e[31m>>>>>>>>>>>> change to app directory and unzip code <<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[31m>>>>>>>>>>>> Download maven dependencies <<<<<<<<<\e[0m"
cd /app
mvn clean package

echo -e "\e[31m>>>>>>>>>>>> move  <<<<<<<<<\e[0m"
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m>>>>>>>>>>>> Copy shipping service file <<<<<<<<<\e[0m"
cp /home/ec2-user/roboshop-shell-2025/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m>>>>>>>>>>>> Daemon reload <<<<<<<<<\e[0m"
systemctl daemon-reload

#echo -e "\e[31m>>>>>>>>>>>> enable and start shipping service <<<<<<<<<\e[0m"
#systemctl enable shipping
#systemctl restart shipping

echo -e "\e[31m>>>>>>>>>>>> Install mysql <<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[31m>>>>>>>>>>>> connect schemas to the root and with password <<<<<<<<<\e[0m"
mysql -h mysql.devopsbymanju.shop -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql.devopsbymanju.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql.devopsbymanju.shop-uroot -pRoboShop@1 < /app/db/master-data.sql

echo -e "\e[31m>>>>>>>>>>>> restart shipping service <<<<<<<<<\e[0m"
systemctl enable shipping
systemctl restart shipping
