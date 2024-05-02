
func_exit_status(){
    if [ $? -eq 0 ];then
        echo -e "\e[36mSUCCESS\e[0m"
    else
        echo -e "\e[36mFAILURE\e[0m"
    fi
}


func_schema_setup(){

    if [ "${schema_type}" == "mongodb" ];then
        echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mongo shell <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
        dnf install mongodb-org-shell -y
        func_exit_status
        mongo --host mongodb.jdevops.online </app/schema/${component}.js
        func_exit_status
    fi

    if [ "${schema_type}" == "mysql" ];then
        echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mysql  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
        dnf install mysql -y 
        func_exit_status
        mysql -h mysql.jdevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql 
        func_exit_status
    fi

}

func_systemd(){
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> systemctl restart <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    systemctl daemon-reload 
    func_exit_status
    systemctl enable ${component} 
    func_exit_status
    systemctl restart ${component} 
    func_exit_status
}

func_appprereq(){


    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> create ${component} service <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    cp ${component}.service /etc/systemd/system/${component}.service 
    func_exit_status
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> adding user <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    useradd roboshop 
    mkdir /app 
    func_exit_status
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> downloadthe ${component} zip file <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
    func_exit_status
    cd /app 
    unzip /tmp/${component}.zip 
    func_exit_status
    cd /app 
    func_exit_status
}


func_nodejs(){

    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> create mongo repo  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
    cp mongo.repo /etc/yum.repos.d/mongo.repo
    func_exit_status
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> installing packages <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    dnf module disable nodejs -y 
    func_exit_status
    dnf module enable nodejs:18 -y
    func_exit_status 
    dnf install nodejs -y
    func_exit_status 
   
    func_appprereq
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> npm install <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    npm install
    
    func_schema_setup
    func_systemd

}

func_java(){

    dnf install maven -y
    func_appprereq
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> Mvn Clean Package <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    mvn clean package 
    func_exit_status
    mv target/${component}-1.0.jar ${component}.jar 
    func_exit_status

    func_schema_setup
    func_exit_status

    func_systemd
    func_exit_status

}

func_python(){

    dnf install python36 gcc python3-devel -y
    func_exit_status
    func_appprereq
    func_exit_status
    echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> python req install <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
    pip3.6 install -r requirements.txt
    func_exit_status
    func_systemd
}