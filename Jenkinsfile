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
          sh '''
            chmod 400 casestudy2key.pem
            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini deploy.yml
          '''
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
