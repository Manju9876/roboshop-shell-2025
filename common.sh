script_path=$(dirname $(realpath $0))
source ${script_path}/common.sh
app_user=roboshop

func_nodejs(){
  echo -e "\e[31m>>>>>>>>>>>>> disable Node js <<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y

  echo -e "\e[31m>>>>>>>>>>>>> enable Node js version 20 <<<<<<<<<<<<<<\e[0m"
  dnf module enable nodejs:20 -y

  echo -e "\e[31m>>>>>>>>>>>>> install Node js <<<<<<<<<<<<<<\e[0m"
  dnf install nodejs -y

  echo -e "\e[31m>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[31m>>>>>>>>>>>>> create a directory <<<<<<<<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[31m>>>>>>>>>>>>> download application code <<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip

  #echo -e "\e[31m>>>>>>>>>>>>> copy catalogue service to systemd <<<<<<<<<<<<<<\e[0m"
  #cp catalogue.service /etc/systemd/system/catalogue.service

  echo -e "\e[31m>>>>>>>>>>>>> unzip application code <<<<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip

  echo -e "\e[31m>>>>>>>>>>>>> install Node js dependencies <<<<<<<<<<<<<<\e[0m"
  npm install

  echo -e "\e[31m>>>>>>>>>>>>> copy catalogue service to systemd <<<<<<<<<<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[31m>>>>>>>>>>>>> reload and start catalogue service  <<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

}