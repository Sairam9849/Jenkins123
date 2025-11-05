pipeline {
  agent any
  environment {
    GIT_URL = 'git@gitbase.example.com:org/repo.git' // CHANGE_ME
    DOCKER_REGISTRY = 'registry.example.com'         // CHANGE_ME
    GIT_CRED = 'GIT_CRED'
    REGISTRY_CRED = 'DOCKER_REGISTRY_CRED'
    SONARQ_CRED = 'SONARQ_TOKEN'
    ARGOCD_TOKEN = credentials('ARGOCD_API_TOKEN')
  }
  parameters {
    string(name: 'BUILD_BRANCH', defaultValue: 'main', description: 'Branch to build')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/${params.BUILD_BRANCH}']],
          userRemoteConfigs: [[url: GIT_URL, credentialsId: GIT_CRED]]])
      }
    }
    stage('Build & Test') {
      parallel {
        stage('Java App') {
          steps {
            dir('spring-boot-app') {
              sh '../ci/scripts/build-java.sh'
            }
          }
        }
        stage('Python App') {
          steps {
            dir('python-jenkins-argoc') {
              sh '../ci/scripts/build-python.sh'
            }
          }
        }
      }
    }
    stage('Docker Build & Push') {
      steps {
        sh 'ci/scripts/build-and-push.sh spring-boot-app registry.example.com DOCKER_REGISTRY_CRED'
        sh 'ci/scripts/build-and-push.sh python-jenkins-argoc registry.example.com DOCKER_REGISTRY_CRED'
      }
    }
    stage('Trigger ArgoCD') {
      when { branch 'main' }
      steps {
        sh 'ci/scripts/trigger-argocd-sync.sh'
      }
    }
  }
  post {
    always { cleanWs() }
  }
}
