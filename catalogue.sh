script_path=$(dirname $(realpath $0))
source ${script_path}/common.sh
echo script_path
exit

component=catalogue

func_nodejs

echo -e "\e[31m>>>>>>>>>>>>> copy mongod repo from mongo.repo <<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>>>>>>> install mongodb <<<<<<<<<<<<<<\e[0m"
dnf install mongodb-mongosh -y

echo -e "\e[31m>>>>>>>>>>>>> connect to schema <<<<<<<<<<<<<<\e[0m"
mongosh --host mongodb-dev.devopsbymanju.shop </app/db/master-data.js
