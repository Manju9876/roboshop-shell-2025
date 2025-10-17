script=$(realpath $0)
script_path=$(dirname "$script")

#script_path=$(dirname $(realpath $0))
#source ${script_path}/common.sh
app_user=roboshop
print_head(){
  echo -e "\e[32m>>>>>>>>>>>>> $* <<<<<<<<<<<<<<\e[0m"
}
func_nodejs(){
  print_head disable Node js
  dnf module disable nodejs -y

  print_head enable Node js version 20
  dnf module enable nodejs:20 -y

  print_head install Node js
  dnf install nodejs -y

  print_head create application user
  useradd ${app_user}

  print_head create a directory
  rm -rf /app
  mkdir /app

  print_head download application code
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip

  #print_head copy catalogue service to systemd
  #cp catalogue.service /etc/systemd/system/catalogue.service

  print_head unzip application code
  cd /app
  unzip /tmp/${component}.zip

  print_head install Node js dependencies
  npm install

  print_head copy catalogue service to systemd
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head reload and start catalogue service
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

}