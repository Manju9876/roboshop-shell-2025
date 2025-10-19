script=$(realpath $0)
script_path=$(dirname "$script")

app_user=roboshop

func_print_head(){
  echo -e "\e[35m>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<\e[0m"
}

func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
  func_print_head "Copy mongod repo from mongo.repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  func_print_head "install mongodb"
  dnf install mongodb-mongosh -y

  func_print_head "connect to schema"
  mongosh --host mongodb-dev.devopsbymanju.shop </app/db/master-data.js
  fi

  if [ "$schema_setup" == "mysql" ]; then
    func_print_head "Install Mysql Client"
    dnf install mysql -y

    func_print_head "connect schemas to the root and with password"
    mysql -h mysql-dev.devopsbymanju.shop -uroot -p${mysql_root_password} < /app/db/schema.sql
    mysql -h mysql-dev.devopsbymanju.shop -uroot -p${mysql_root_password} < /app/db/app-user.sql
    mysql -h mysql-dev.devopsbymanju.shop -uroot -p${mysql_root_password} < /app/db/master-data.sql
  fi
}

func_app_prereq(){
   func_print_head "create Application  user"
    useradd ${app_user}

   func_print_head "delete any existing /app dir and create app directory"
    rm -rf /app
    mkdir /app

   func_print_head "Download Application code"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip

   func_print_head "Change to /app directory and unzip code"
    cd /app
    unzip /tmp/${component}.zip

}

func_systemd_setup(){
   func_print_head "Copy service file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

   func_print_head "Daemon reload"
      systemctl daemon-reload

   func_print_head "Start ${component} service"
      systemctl enable ${component}
      systemctl restart ${component}

}

func_nodejs(){
  func_print_head "disable Node js"
  dnf module disable nodejs -y

  func_print_head "enable Node js version 20"
  dnf module enable nodejs:20 -y

  func_print_head "install Node js"
  dnf install nodejs -y

  func_app_prereq

  func_print_head "install Node js dependencies"
  npm install

  func_schema_setup

  func_systemd_setup

}

func_java(){
 func_print_head "Install maven"
  dnf install maven -y

 func_app_prereq

 func_print_head "Download maven dependencies"
  cd /app
  mvn clean package

 func_print_head "Moving shipping.jar file from target dir"
  mv target/${component}-1.0.jar ${component}.jar

 func_schema_setup

 func_systemd_setup

}