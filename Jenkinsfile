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
                    
                    // Securely retrieve credentials by ID 'dockerhub-creds'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        
                        // Execute deploy.sh via WSL, passing the four required arguments:
                        // $1=Docker_Login_User, $2=Docker_Password, $3=Docker_Image_Repo_User, $4=Image_Name
                        bat "${WSL_PATH} ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER} ${IMAGE_NAME}"
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