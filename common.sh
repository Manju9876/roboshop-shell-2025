script=$(realpath $0)
script_path=$(dirname "$script")

app_user=roboshop
log_file=/tmp/roboshop.log
# rm -rf /tmp/roboshop.log

func_print_head(){

  echo -e "\e[35m>>>>>>>>>>>>> $1 <<<<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>>>>> $1 <<<<<<<<<<<<\e[0m"  &>>${log_file}

}

func_status_check(){

    if [ $1 = 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[31m"
      echo -e "\e[31mRefer the /tmp/roboshop.log  file for more information"
      exit 1
    fi
}
func_schema_setup(){

  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy mongod repo from mongo.repo"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
      func_status_check $?

    func_print_head "install mongodb"
      dnf install mongodb-mongosh -y &>>${log_file}
      func_status_check $?

    func_print_head "connect to schema"
      mongosh --host mongodb-dev.devopsbymanju.shop </app/db/master-data.js &>>${log_file}
      func_status_check $?
  fi

  if [ "$schema_setup" == "mysql" ]; then
    func_print_head "Install Mysql Client"
      dnf install mysql -y &>>${log_file}
      func_status_check $?

    func_print_head "connect schemas to the root and with password"
      mysql -h mysql-dev.devopsbymanju.shop -uroot -p${mysql_root_password} < /app/db/schema.sql &>>${log_file}
      mysql -h mysql-dev.devopsbymanju.shop -uroot -p${mysql_root_password} < /app/db/app-user.sql &>>${log_file}
      mysql -h mysql-dev.devopsbymanju.shop -uroot -p${mysql_root_password} < /app/db/master-data.sql &>>${log_file}
      func_status_check $?
  fi
}

func_app_prereq(){

   func_print_head "create Application  user"
     id ${app_user} &>>${log_file}
     if [ $? -ne 0 ]; then
      useradd ${app_user} &>>${log_file}
     fi
     func_status_check $?

   func_print_head "delete any existing /app dir and create app directory"
     rm -rf /app &>>${log_file}
     mkdir /app &>>${log_file}
     func_status_check $?

   func_print_head "Download Application code"
     curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>${log_file}
     func_status_check $?

   func_print_head "Change to /app directory and unzip code"
     cd /app &>>${log_file}
     unzip /tmp/${component}.zip &>>${log_file}
     func_status_check $?

}

func_systemd_setup(){

   func_print_head "Copy service file"
     cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
     func_status_check $?

   func_print_head "Daemon reload"
      systemctl daemon-reload &>>${log_file}
      func_status_check $?

   func_print_head "Start ${component} service"
      systemctl enable ${component} &>>${log_file}
      systemctl restart ${component} &>>${log_file}
      func_status_check $?

}

func_nodejs(){

  func_print_head "disable Node js"
  dnf module disable nodejs -y &>>${log_file}
  func_status_check $?

  func_print_head "enable Node js version 20"
  dnf module enable nodejs:20 -y &>>${log_file}
  func_status_check $?

  func_print_head "install Node js"
  dnf install nodejs -y &>>${log_file}
  func_status_check $?

  func_app_prereq

  func_print_head "install Node js dependencies"
  npm install &>>${log_file}
  func_status_check $?

  func_schema_setup

  func_systemd_setup

}

func_java(){

 func_print_head "Install maven"
  dnf install maven -y &>>${log_file}
  func_status_check $?

 func_app_prereq

 func_print_head "Download maven dependencies"
  cd /app &>>${log_file}
  mvn clean package &>>${log_file}
  func_status_check $?

 func_print_head "Moving shipping.jar file from target dir"
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
 func_status_check $?

 func_schema_setup

 func_systemd_setup

}

func_golang(){
  
  func_print_head "Install golang"
    dnf install golang -y &>>${log_file}
    func_status_check $?

   func_app_prereq
  
  func_print_head "Download golang dependencies"
    go mod init ${component} &>>${log_file}
    func_status_check $?
    go get &>>${log_file}
    func_status_check $?
    go build &>>${log_file}
    func_status_check $?

  func_systemd_setup

}