script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_app_username=$1
rabbitmq_app_users_password=$2

component=dispatch
func_golang

