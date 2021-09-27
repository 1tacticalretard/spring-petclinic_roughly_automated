#!/bin/bash
export db_instance_id="$(<~/db_instance_id.txt)"
sed -i "s/localhost/$db_instance_id/g" /home/ubuntu/spring-petclinic/src/main/resources/application-mysql.properties
#sed -i "s/h2/mysql/g" ~/spring-petclinic/src/main/resources/application.properties
