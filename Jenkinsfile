pipeline {
    agent any

    environment {
        // CRITICAL: REPLACE 'Hepziba01' with your correct Docker Hub/GitHub username
        DOCKERHUB_USER = 'Hepziba01' 
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
        
        // Explicit path to WSL executable for reliable execution on Windows
        WSL_PATH = 'C:/Windows/System32/wsl.exe' 
    }

    stages {
        stage('1. Checkout from GitHub') {
            steps {
                echo "Pulling code from ${env.DOCKERHUB_USER}/devops-project"
                // Uses the SCM configuration from the Jenkins job setup
                checkout scm 
            }
        }

        stage('2. Build and Push Docker Image') {
            steps {
                script {
                    echo "--- Building Docker Image via WSL ---"
                    // Execute Docker build command inside the WSL environment
                    bat "${WSL_PATH} docker build -t ${IMAGE_NAME} ."
                    
                    echo "--- Pushing Image to Docker Hub ---"
                    // Use the securely stored credentials (ID: dockerhub-creds)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        // Login and push commands run inside WSL
                        bat "${WSL_PATH} docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        bat "${WSL_PATH} docker push ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage('3. Deploy with Ansible') {
            steps {
                script {
                    echo "--- Starting Ansible Deployment via WSL ---"
                    // Execute the Ansible playbook using WSL
                    // This runs playbook.yml against the inventory file
                    bat "${WSL_PATH} ansible-playbook playbook.yml -i inventory"
                }
            }
        }
    }

    post {
        always {
            // Log out of Docker Hub for security cleanup
            bat "${WSL_PATH} docker logout"
            echo "Deployment finished. Check target server IP."
        }
    }
}