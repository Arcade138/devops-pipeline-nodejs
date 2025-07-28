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

    stage('Build Docker Image') {
      steps {
        dir('devops-pipeline-nodejs') {
          sh './scripts/build_and_push.sh'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('devops-pipeline-nodejs/infra') {
          sh '''
            terraform init
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        dir('devops-pipeline-nodejs') {
          sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/hosts.ini ansible/deploy.yml'
        }
      }
    }

    stage('Cleanup') {
      steps {
        dir('devops-pipeline-nodejs') {
          sh './scripts/cleanup.sh'
        }
      }
    }
  }
}

