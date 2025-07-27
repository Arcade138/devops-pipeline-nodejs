pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "diyacapg/myapp:${env.BUILD_ID}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/Arcade138/devops-pipeline-nodejs.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                sh 'chmod +x scripts/build_and_push.sh'
                sh './scripts/build_and_push.sh'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var="key_name=casestudy2key"'
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                sh 'ansible-playbook -i ansible/hosts.ini ansible/deploy.yml'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
