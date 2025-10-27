script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head "Dsiable nginx"
  dnf module disable nginx -y &>>${log_file}
  func_status_check $?

func_print_head "Enable nginx version 1.24 "
  dnf module enable nginx:1.24 -y  &>>${log_file}
  func_status_check $?

func_print_head "Install nginx "
  dnf install nginx -y  &>>${log_file}
  func_status_check $?

func_print_head "Remove Nginx data "
  rm -rf /usr/share/nginx/html/*  &>>${log_file}
  func_status_check $?

func_print_head "Download frontend code "
  curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip  &>>${log_file}
  func_status_check $?

func_print_head "Unzip code "
  cd /usr/share/nginx/html  &>>${log_file}
  unzip /tmp/frontend.zip  &>>${log_file}
  func_status_check $?

func_print_head "Copy nginx configuration file "
  cp ${script_path}/nginx.conf /etc/nginx/nginx.conf  &>>${log_file}
  func_status_check $?

func_print_head "start nginx service "
  systemctl enable nginx  &>>${log_file}
  systemctl restart nginx  &>>${log_file}
  func_status_check $?






