pipeline {
    agent any

    environment {
        // CRITICAL: GitHub username is used here for the code repo URL
        GITHUB_USER = 'Hepziba01' 
        
        // CRITICAL: Docker Hub username is used here for the image name
        DOCKERHUB_USER = 'hepziba' 
        IMAGE_NAME = "${DOBERHUB_USER}/devops-project:latest"
        WSL_PATH = 'C:/Windows/System32/wsl.exe' 
    }

    stages {
        stage('1. Checkout from GitHub') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                // Uses GITHUB_USER for the repository URL
                git branch: 'main', url: "https://github.com/${env.GITHUB_USER}/devops-project.git" 
            }
        }

        stage('2. Build, Push & Deploy (Via Script)') {
            steps {
                script {
                    echo "--- Executing full CI/CD via deploy.sh in WSL ---"
                    // Pass ALL three usernames/passwords to the script
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        
                        // Arguments: $DOCKER_USER $DOCKER_PASS $DOCKERHUB_USER
                        // DOCKER_USER (Hepziba) is passed as the third argument
                        bat "${WSL_PATH} ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "CI/CD Pipeline Completed."
        }
    }
}