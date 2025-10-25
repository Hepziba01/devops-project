pipeline {
    agent any

    environment {
        // --- Corrected Variables ---
        GITHUB_USER = 'Hepziba01'
        DOCKERHUB_USER = 'hepziba'
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
        // Using PowerShell doesn't change the need for the WSL path
        WSL_PATH = 'C:/Windows/System32/wsl.exe'
    }

    stages {
        stage('1. Checkout and Setup Permissions') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm

                // Use powershell to call WSL for chmod
                echo "Setting execute permission on deploy.sh"
                powershell "${env.WSL_PATH} chmod +x deploy.sh"
            }
        }

        stage('2. Execute Deployment Script') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {

                        // Use powershell to call WSL to execute the script
                        powershell "${env.WSL_PATH} ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER} ${IMAGE_NAME}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Use powershell to call WSL for logout
            powershell "${env.WSL_PATH} docker logout"
            echo "CI/CD Pipeline Completed. Final status is ${currentBuild.result}"
        }
    }
}