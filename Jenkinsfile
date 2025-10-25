pipeline {
    agent any

    environment {
        // --- Corrected Variables ---
        GITHUB_USER = 'Hepziba01'         // Your GitHub username
        DOCKERHUB_USER = 'hepziba'        // Your Docker Hub username
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest" // Image name using Docker Hub user
        WSL_PATH = 'C:/Windows/System32/wsl.exe'
    }

    stages {
        stage('1. Checkout and Setup') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm
                // Note: The chmod +x is now correctly inside the single bash execution below
            }
        }

        stage('2. Build, Push & Deploy (Via Script)') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {

                        // FINAL FIX V7: Use BAT to call WSL which runs BASH to execute the commands in ONE session
                        bat """
                            ${env.WSL_PATH} /bin/bash -c "
                                chmod +x deploy.sh;
                                ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER} ${IMAGE_NAME}
                            "
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "CI/CD Pipeline Completed. Final status is ${currentBuild.result}"
        }
    }
}