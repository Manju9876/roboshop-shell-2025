script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Disable redis "
  dnf module disable redis -y &>>${log_file}
  func_status_check $?

func_print_head "Enable redis version 7"
  dnf module enable redis:7 -y &>>${log_file}
  func_status_check $?

func_print_head "Install redis"
  dnf install redis -y &>>${log_file}
  func_status_check $?

func_print_head "change localhost to 0.0.0.0 in redis.conf"
  sed -i '87s|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf &>>${log_file}
  func_status_check $?
  sed -i '111s|yes|no|' /etc/redis/redis.conf &>>${log_file}
  func_status_check $?

func_print_head "enable and start redis"
  systemctl enable redis &>>${log_file}
  func_status_check $?
  systemctl restart redis &>>${log_file}
  func_status_check $?


