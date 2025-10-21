script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_app_username=$1
rabbitmq_app_users_password=$2

if [ -z "${rabbitmq_app_username}" ] || [ -z "${rabbitmq_app_users_password}" ]; then
   echo -e "\e[31m❌ Input missing!\e[0m"
   echo -e "\e[31mUsage: sudo bash script-name.sh <rabbitmq_app_username> <rabbitmq_app_users_password>\e[0m"
   exit 1
fi


component=dispatch
func_golang

