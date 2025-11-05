
pipeline {
    agent any
    stages {
        stage('Trigger ArgoCD Sync') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ARGOCD_CRED', usernameVariable: 'ARGOCD_USER', passwordVariable: 'ARGOCD_PASS')]) {
                    bat """
                        echo Logging in to ArgoCD...
                        argocd login argocd.example.com --username %ARGOCD_USER% --password %ARGOCD_PASS% --grpc-web
                        echo Syncing ArgoCD application...
                        argocd app sync my-app --retry
                        argocd app wait my-app --health --timeout 300
                    """
                }
            }
        }
    }
}
