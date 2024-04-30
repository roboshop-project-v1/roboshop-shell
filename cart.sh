
log=/tmp/log.txt
echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> create cart service <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
cp cart.service /etc/systemd/system/cart.service &>>${log}

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> installing packages <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}
dnf install nodejs -y &>>${log}
echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> adding user <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
useradd roboshop &>>${log}
mkdir /app &>>${log}
echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> downloadthe cart zip file <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${log}
cd /app &>>${log}
unzip /tmp/cart.zip &>>${log}

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> npm install <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 

cd /app &>>${log}
npm install &>>${log}

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> systemctl restart <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" 

systemctl daemon-reload &>>${log}
systemctl enable cart &>>${log}
systemctl restart cart &>>${log}


