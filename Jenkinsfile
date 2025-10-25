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
        stage('1. Checkout and Setup') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm
            }
        }

        stage('2. Build, Push & Deploy (Via Script)') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {

                        // FINAL FIX V6: Use BAT to call WSL which runs BASH to execute the commands
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