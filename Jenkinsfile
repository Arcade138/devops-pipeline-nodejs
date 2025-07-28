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
        git branch: 'develop', url: 'https://github.com/Arcade138/devops-pipeline-nodejs.git'
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

    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          withCredentials([
            string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
            string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
          ]) {
            sh '''
              terraform init
              terraform apply -auto-approve \
                -var "AWS_ACCESS_KEY=${AWS_ACCESS_KEY}" \
                -var "AWS_SECRET_KEY=${AWS_SECRET_KEY}"
            '''
          }
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        sh '''
          ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/hosts.ini ansible/deploy.yml
        '''
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
