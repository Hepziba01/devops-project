pipeline {
    agent any

    environment {
        // --- Corrected Variables ---
        GITHUB_USER = 'Hepziba01'
        DOCKERHUB_USER = 'hepziba'
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
        // Note: We use 'sh' now, which handles the WSL call cleaner than 'bat'
    }

    stages {
        stage('1. Checkout and Setup') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm 
            }
        }

        stage('2. Build, Push & Deploy') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        
                        // THIS IS THE FINAL FIX: Run all commands via ONE 'sh' call inside WSL
                        // The 'sh' step handles the environment transition more gracefully.
                        sh """
                            # Ensure the script is executable
                            chmod +x deploy.sh
                            
                            # Execute the script, passing arguments and relying on fixes made to deploy.sh
                            ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER} ${IMAGE_NAME}
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