script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  func_print_head "Input  for mysql root password missing"
  exit
fi

func_print_head "install mysql"
  dnf install mysql-server -y &>>${log_file}
  func_status_check $?

func_print_head "enable and start mysql"
  systemctl enable mysqld &>>${log_file}
  func_status_check $?
  systemctl start mysqld &>>${log_file}
  func_status_check $?

func_print_head "Change default password"
  mysql_secure_installation --set-root-pass ${mysql_root_password}
