source common.sh

dnf install nginx -y
func_exit_status
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
func_exit_status

rm -rf /usr/share/nginx/html/* 
func_exit_status
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
func_exit_status
cd /usr/share/nginx/html 
func_exit_status
unzip /tmp/frontend.zip
func_exit_status
systemctl enable nginx
func_exit_status 
systemctl restart nginx
func_exit_status 
