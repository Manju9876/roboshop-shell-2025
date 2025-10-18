script=$(realpath $0)
script_path=$(dirname "$script")

app_user=roboshop

func_print_head(){
  echo -e "\e[35m>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<\e[0m"
}

func_schema_setup(){
  if [ "$schema_setup" = "mongo" ]; then
  func_print_head "Copy mongod repo from mongo.repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  func_print_head "install mongodb"
  dnf install mongodb-mongosh -y

  func_print_head "connect to schema"
  mongosh --host mongodb-dev.devopsbymanju.shop </app/db/master-data.js
  fi
}

func_nodejs(){
  func_print_head "disable Node js"
  dnf module disable nodejs -y

  func_print_head "enable Node js version 20"
  dnf module enable nodejs:20 -y

  func_print_head "install Node js"
  dnf install nodejs -y

  func_print_head "create application user"
  useradd ${app_user}

  func_print_head "create a directory"
  rm -rf /app
  mkdir /app

  func_print_head "download application code"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip

  #print_head copy catalogue service to systemd
  #cp catalogue.service /etc/systemd/system/catalogue.service

  func_print_head "unzip application code"
  cd /app
  unzip /tmp/${component}.zip

  func_print_head "install Node js dependencies"
  npm install

  func_print_head "copy catalogue service to systemd"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "reload and start catalogue service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

  func_schema_setup

}