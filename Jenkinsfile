stage('Trigger ArgoCD Sync') {
    steps {
        script {
            withCredentials([usernamePassword(credentialsId: 'ARGOCD_CRED', usernameVariable: 'ARGOCD_USER', passwordVariable: 'ARGOCD_PASS')]) {
                bat """
                    echo Logging in to ArgoCD...
                    C:\\tools\\argocd.exe login argocd.example.com --username %ARGOCD_USER% --password %ARGOCD_PASS% --grpc-web
                    echo Syncing ArgoCD application...
                    C:\\tools\\argocd.exe app sync my-app --retry
                    C:\\tools\\argocd.exe app wait my-app --health --timeout 300
                """
            }
        }
    }
}
