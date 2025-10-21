script_path=$(dirname $(realpath $0))
source ${script_path}/common.sh
rabbitmq_app_username=$1
rabbitmq_app_users_password=$2

if [ -z "${rabbitmq_app_username}" ] || [ -z "${rabbitmq_app_users_password}" ]; then
   echo -e "\e[31m❌ Input missing!\e[0m"
   echo -e "\e[31mUsage: sudo bash script-name.sh <rabbitmq_app_username> <rabbitmq_app_users_password>\e[0m"
   exit 1
fi

func_print_head "copy repo file "
cp ${script_path}/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>${log_file}
func_status_check $?

func_print_head "Install rabbitMQ"
dnf install rabbitmq-server -y &>>${log_file}
  func_status_check $?

func_print_head "enable and start rabbitMQ"
  systemctl enable rabbitmq-server &>>${log_file}
  systemctl restart rabbitmq-server &>>${log_file}
  func_status_check $?

func_print_head "add user and password"
  rabbitmqctl add_user ${rabbitmq_app_username} ${rabbitmq_app_users_password} &>>${log_file}
  func_status_check $?

func_print_head "set permissions"
  rabbitmqctl set_permissions -p / ${rabbitmq_app_username} ".*" ".*" ".*" &>>${log_file}
  func_status_check $?
