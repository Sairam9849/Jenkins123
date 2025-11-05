pipeline {
    agent any

    stages {
        // ✅ Stage 1: Checkout code from Git
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/Sairam9849/Jenkins123.git', branch: 'main'
            }
        }

        // ✅ Stage 2: Build & Test - Java (runs if pom.xml exists)
        stage('Build & Test - Java') {
            when { expression { fileExists('pom.xml') } }
            steps {
                echo 'Building Java project...'
                sh 'mvn clean install'
            }
        }

        // ✅ Stage 3: Build & Test - Python (runs if requirements.txt exists)
        stage('Build & Test - Python') {
            when { expression { fileExists('requirements.txt') } }
            steps {
                echo 'Running Python tests...'
                sh 'pytest'
            }
        }

        // ⚪ Stage 4: Docker Build & Push (optional, runs if Dockerfile exists)
        stage('Docker Build & Push') {
            when { expression { fileExists('Dockerfile') } }
            steps {
                echo 'Building and pushing Docker image...'
                sh 'docker build -t myimage:latest .'
                sh 'docker push myimage:latest'
            }
        }

        // ✅ Stage 5: Trigger ArgoCD Deployment
        stage('Trigger ArgoCD Sync') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ARGOCD_CRED', usernameVariable: 'ARGOCD_USER', passwordVariable: 'ARGOCD_PASS')]) {
                    sh """
                        echo "Logging in to ArgoCD..."
                        argocd login argocd.example.com --username $ARGOCD_USER --password $ARGOCD_PASS --grpc-web
                        echo "Syncing ArgoCD application..."
                        argocd app sync my-app --retry
                        argocd app wait my-app --health --timeout 300
                    """
                }
            }
        }

        // ⚪ Stage 6: E2E Tests (optional, runs if cypress.json exists)
        stage('E2E Tests') {
            when { expression { fileExists('cypress.json') } }
            steps {
                echo 'Running E2E tests...'
                sh 'npx cypress run'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
