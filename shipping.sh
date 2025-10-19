script_path=$(dirname $0)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  print_func_head "Input of Mysql root password is missing"
  exit
fi

component=shipping