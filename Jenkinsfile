pipeline {
  agent any

  environment {
    IMAGE_NAME = 'diyacapg/myapp'
  }

  stages {

    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }

    stage('Clone Repo') {
      steps {
        git branch: 'develop', credentialsId: 'github-pat', url: 'https://github.com/Arcade138/devops-pipeline-nodejs.git'
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        script {
          sh 'chmod +x scripts/build_and_push.sh'
          sh './scripts/build_and_push.sh'
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        dir('ansible') {
          withCredentials([file(credentialsId: 'aws-ec2-key', variable: 'EC2_KEY')]) {
            sh '''
              chmod 400 $EC2_KEY
              ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini deploy.yml --private-key=$EC2_KEY
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline succeeded'
    }
    failure {
      echo '❌ Pipeline failed'
    }
  }
}
