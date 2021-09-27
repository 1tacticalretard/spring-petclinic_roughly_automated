pipeline {
    agent any
    tools {
        terraform 'Terraform' 
    }
    stages {
        stage ('Application setup @ AWS') {
            steps {
                
                sh "cd /home/eugene/petclinic_d+tf && sudo terraform init; \
                sudo terraform apply -auto-approve;"
            }
        }
    }
}
