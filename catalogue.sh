
echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> create catalogue service <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> create mongo repo  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"

cp mongo.repo /etc.yum.repos.d/mongo.repo

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> download catalogue zip file <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> installing packages <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> add user <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"

useradd roboshop
mkdir /app 

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> unzip catalogue zip file <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app 
unzip /tmp/catalogue.zip
cd /app 
npm install

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mongo shell <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
mongo --host mongodb.jdevops.online </app/schema/catalogue.js

echo -e "\e[35m>>>>>>>>>>>>>>>>>>>>>>>>>>> systemctl reastart <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

