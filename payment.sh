script_path=$(dirname $0)
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]
then
  echo Input of rabbitMQ passowrd is missing
  exit
fi

echo -e "\e[31m>>>>>>>>>>>>> Install Python <<<<<<<<<<<<<<<\e[0m"
dnf install python3 gcc python3-devel -y

echo -e "\e[31m>>>>>>>>>>>>> create app user  <<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m>>>>>>>>>>>>> create a directory <<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>> download app content <<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip

echo -e "\e[31m>>>>>>>>>>>>> copy payment service file <<<<<<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[31m>>>>>>>>>>>>> navigate to /app and unzip app content <<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[31m>>>>>>>>>>>>> download python dependencies <<<<<<<<<<<<<<<\e[0m"
pip3 install -r requirements.txt

echo -e "\e[31m>>>>>>>>>>>>> reload systemd file <<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[31m>>>>>>>>>>>>> enable and restart payment service <<<<<<<<<<<<<<<\e[0m"
systemctl enable payment
systemctl restart payment