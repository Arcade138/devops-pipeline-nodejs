pipeline {
  agent any

  environment {
    IMAGE_NAME = 'diyacapg/myapp:${GIT_COMMIT_SHORT}'
  }

  triggers {
    cron('H 1 * * *') // Optional daily trigger
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

    stage('Build Docker Image') {
      steps {
        sh './scripts/build_and_push.sh'
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([file(credentialsId: 'aws-creds', variable: 'AWS_CREDENTIALS_FILE')]) {
          dir('infra') {
            sh '''
              export AWS_SHARED_CREDENTIALS_FILE=$AWS_CREDENTIALS_FILE
              terraform init
              terraform apply -auto-approve
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

    stage('Cleanup') {
      steps {
        sh './scripts/cleanup.sh'
      }
    }
  }

  post {
    success {
      echo '✅ CI/CD pipeline completed successfully.'
    }
    failure {
      echo '❌ CI/CD pipeline failed.'
    }
  }
}
