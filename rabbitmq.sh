script_path=$(dirname $(realpath $0))
source ${script_path}/common.sh

echo -e "\e[31m>>>>>>>>>>>>> copy repo file <<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

echo -e "\e[31m>>>>>>>>>>>>> Install rabbitMQ <<<<<<<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[31m>>>>>>>>>>>>> add user and password <<<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123

echo -e "\e[31m>>>>>>>>>>>>> set permissions <<<<<<<<<<<<<<<\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo -e "\e[31m>>>>>>>>>>>>> enable and start rabbitMQ <<<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server