dnf install maven -y
useradd roboshop
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip
cp shipping.service /etc/systemd/system/shipping.service
cd /app
unzip /tmp/shipping.zip
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

dnf install mysql -y
mysql -h mysql.devopsbymanju.shop -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql.devopsbymanju.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql.devopsbymanju.shop-uroot -pRoboShop@1 < /app/db/master-data.sql

systemctl restart shipping