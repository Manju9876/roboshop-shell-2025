script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Copy repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
func_status_check $?

func_print_head "install mongod "
dnf install mongodb-org -y &>>${log_file}
func_status_check $?

func_print_head "Edit and set 12.0.0.0 to 0.0.0.0 in mongod.conf"
sed  -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}
func_status_check $?

func_print_head "Enable and start mongod"
systemctl enable mongod &>>${log_file}
systemctl restart  mongod &>>${log_file}
func_status_check $?

