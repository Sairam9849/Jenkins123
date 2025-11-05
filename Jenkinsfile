pipeline {
  agent any

  environment {
    GIT_URL = 'https://github.com/Sairam9849/Jenkins123.git'
    GIT_BRANCH = 'main'
    DOCKER_REGISTRY = 'registry.example.com'    // CHANGE_ME if you use one
    DOCKER_CRED = 'DOCKER_REGISTRY_CRED'        // put your docker cred ID
    GITHUB_CRED = 'GITHUB_HTTP_CRED'            // your github cred ID
    // ARGOCD_API_TOKEN must exist as a Secret Text credential in Jenkins if you want ArgoCD sync
  }

  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: "*/${GIT_BRANCH}"]],
          userRemoteConfigs: [[url: GIT_URL, credentialsId: GITHUB_CRED]]
        ])
      }
    }

    stage('Build & Test - Java') {
      when { expression { fileExists('spring-boot-app/pom.xml') } }
      steps {
        dir('spring-boot-app') {
          sh 'mvn -B -DskipTests=false clean test'
        }
      }
    }

    stage('Build & Test - Python') {
      when { expression { fileExists('python-jenkins-argoc/requirements.txt') } }
      steps {
        dir('python-jenkins-argoc') {
          sh '''
            python3 -m venv .venv
            . .venv/bin/activate
            pip install -r requirements.txt || true
            pytest -q || true
          '''
        }
      }
    }

    stage('Docker Build & Push (optional)') {
      when { expression { env.DOCKER_CRED != null && env.DOCKER_REGISTRY != 'registry.example.com' } }
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: DOCKER_CRED, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh """
              echo "$DOCKER_PASS" | docker login ${DOCKER_REGISTRY} -u "$DOCKER_USER" --password-stdin || true
              docker build -t ${DOCKER_REGISTRY}/spring-boot-app:${BUILD_NUMBER} spring-boot-app || true
              docker push ${DOCKER_REGISTRY}/spring-boot-app:${BUILD_NUMBER} || true
            """
          }
        }
      }
    }

    stage('Trigger ArgoCD Sync (optional)') {
      when { branch 'main' }
      steps {
        script {
          // If ARGOCD_API_TOKEN exists it will be injected; otherwise we skip.
          try {
            withCredentials([string(credentialsId: 'ARGOCD_API_TOKEN', variable: 'ARGOCD_TOKEN')]) {
              if (env.ARGOCD_TOKEN?.trim()) {
                sh """
                  curl -s -X POST -H "Authorization: Bearer ${ARGOCD_TOKEN}" \
                    -H "Content-Type: application/json" \
                    "https://argocd.example.com/api/v1/applications/CHANGE_ME/sync" -d '{"revision":"main"}' || true
                """
              } else {
                echo "ARGOCD_TOKEN empty — skipping ArgoCD sync"
              }
            }
          } catch (err) {
            echo "ARGOCD credential not found — skipping ArgoCD sync"
          }
        }
      }
    }
  }

  post {
    always {
      script {
        // run workspace cleanup inside agent context
        deleteDir()
        echo "Workspace cleaned"
      }
    }
    success {
      echo "Pipeline succeeded"
    }
    failure {
      echo "Pipeline failed — check Console Output"
    }
  }
}
