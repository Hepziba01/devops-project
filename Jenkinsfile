pipeline {
    agent any

    environment {
        // --- Corrected Variables ---
        GITHUB_USER = 'Hepziba01'
        DOCKERHUB_USER = 'hepziba'
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
        WSL_PATH = 'C:/Windows/System32/wsl.exe'
    }

    stages {
        stage('1. Checkout Code') { // Simplified stage name
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm 
                // Removed the problematic chmod step
            }
        }

        stage('2. Build, Push & Deploy (Via Script)') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        
                        // FINAL FIX V10: Execute the script explicitly with 'bash'
                        // This bypasses the need for chmod +x
                        powershell "${env.WSL_PATH} bash ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER} ${IMAGE_NAME}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Use powershell for logout
            powershell "${env.WSL_PATH} docker logout"
            echo "CI/CD Pipeline Completed. Final status is ${currentBuild.result}"
        }
    }
}