source common.sh

echo -e "\e[31m>>>>>>>>>>>>>install golang<<<<<<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[31m>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m>>>>>>>>>>>>> Create app directory <<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>>Download app content<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip

echo -e "\e[31m>>>>>>>>>>>>>copy dispatch service file <<<<<<<<<<<<<<\e[0m"
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[31m>>>>>>>>>>>>> navigate to /app and unzip the content <<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[31m>>>>>>>>>>>>>download golang dependencies<<<<<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[31m>>>>>>>>>>>>>daemon reload the disptatch file<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[31m>>>>>>>>>>>>>enable and restart the dipatch service<<<<<<<<<<<<<<\e[0m"
systemctl enable dispatch
systemctl start dispatch