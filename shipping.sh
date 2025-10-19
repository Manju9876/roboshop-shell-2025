script_path=$(dirname $0)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  echo -e "\e[31mInput of Mysql root password is missing\e[0m"
  exit
fi


component=shipping
schema_setup=mysql
func_java