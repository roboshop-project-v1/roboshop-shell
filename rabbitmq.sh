rabbitmq_app_passwd=$1
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

dnf install rabbitmq-server -y 

systemctl enable rabbitmq-server 
systemctl restart rabbitmq-server 
rabbitmqctl add_user roboshop ${rabbitmq_app_passwd}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"