pipeline {
    agent any

    environment {
        // --- Corrected Variables ---
        GITHUB_USER = 'Hepziba01'         // Used for code checkout URL
        DOCKERHUB_USER = 'hepziba'        // Corrected typo, used for image name and login
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest" // CORRECTED: DOCKERHUB_USER
        WSL_PATH = 'C:/Windows/System32/wsl.exe'
    }

    stages {
        stage('1. Checkout and Setup') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm 
                
                // CRITICAL FIX: Add the execute permission to the deploy.sh script inside WSL
                bat "${env.WSL_PATH} chmod +x deploy.sh" 
            }
        }

        stage('2. Build, Push & Deploy (Via Script)') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        
                        // THIS IS THE FIX: Run chmod and deploy.sh in ONE single, continuous WSL session
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