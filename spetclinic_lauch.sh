#!/bin/bash

cd /home/eugene/dockerized_petclinic/ && instance_id=$(<instance_id.txt)
export db_instance_id="$(<~/dockerized_petclinic/db_instance_id.txt)"
#ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "cd /home/ubuntu/application/ && java -jar spring-petclinic-2.4.5.jar"
scp -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no /home/eugene/dockerized_petclinic/Dockerfile ubuntu@$instance_id:/home/ubuntu/
#scp -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no /home/eugene/dockerized_petclinic/mysql_part.txt ubuntu@$instance_id:/home/ubuntu
scp -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no /home/eugene/dockerized_petclinic/db_instance_id.txt ubuntu@$instance_id:/home/ubuntu
scp -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no /home/eugene/dockerized_petclinic/spetclinic_update.sh ubuntu@$instance_id:/home/ubuntu
ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "export db_instance_id=$(</home/ubuntu/db_instance_id.txt)"
ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "mysql -h $db_instance_id -P 3306 -u petclinic -ppetclinic < mysql_part.txt"
ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "sudo chmod u+x spetclinic_update.sh \
&& git clone https://github.com/spring-projects/spring-petclinic.git \
&& export db_instance_id="$(<db_instance_id.txt)" MYSQL_PASS="petclinic" MYSQL_USER= "petclinic" MYSQL_URL="jdbc:mysql://$db_instance_id" \
&& sleep 5 \
&& /bin/bash spetclinic_update.sh \
&& sudo mv Dockerfile /home/ubuntu/spring-petclinic \
&& cd /home/ubuntu/spring-petclinic \
&& ./mvnw clean package -Dspring-boot.run.profiles=mysql -DskipTests  \
&& cd /home/ubuntu \
&& cd /home/ubuntu/spring-petclinic \
&& sudo docker build -t spring-petclinic . \
&& sudo docker run -d -p 8080:8080 spring-petclinic "


#ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "sudo chmod u+x /home/ubuntu/sp-run.sh"
#ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "sudo mv /home/ubuntu/spring-petclinic.service /etc/systemd/system/"
#ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "sudo systemctl daemon-reload && sudo systemctl enable spring-petclinic.service"
#ssh -i "/home/eugene/Downloads/yoba.pem" -o StrictHostKeyChecking=no ubuntu@$instance_id "sudo systemctl start spring-petclinic.service" 
#

