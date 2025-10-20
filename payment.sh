script_path=$(dirname $0)
source ${script_path}/common.sh
rabbitmq_app_username=$1
rabbitmq_app_users_password=$2

if [ -z "$rabbitmq_app_users_password" ]; then
  echo Input of rabbitMQ user passowrd is missing
  echo Kindly enter the rabbitMQ user name and Password
  exit
fi

component=payment
func_python