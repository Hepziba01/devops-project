pipeline {
    agent any

    environment {
        // Your Docker Hub username (must be correct!)
        DOCKERHUB_USER = 'Hepziba01' // <-- REPLACE THIS
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
        
        // This is the CRITICAL change: defining the path to WSL/Docker in the script environment
        WSL_PATH = 'C:/Windows/System32/wsl.exe' 
    }

    stages {
        stage('1. Checkout from GitHub') {
            steps {
                // Ensure SCM settings are used
                checkout scm 
            }
        }

        stage('2. Build and Push Docker Image') {
            steps {
                script {
                    // Use bat to call WSL to run the Docker commands inside Linux
                    echo "--- Building Docker Image via WSL ---"
                    bat "${WSL_PATH} docker build -t ${IMAGE_NAME} ."
                    
                    // Push to Docker Hub using the 'dockerhub-creds' credential ID
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        echo "--- Pushing Image to Docker Hub via WSL ---"
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
                    // Execute Ansible playbook using WSL
                    bat "${WSL_PATH} ansible-playbook playbook.yml -i inventory"
                }
            }
        }
    }

    post {
        always {
            // Log out of Docker Hub
            bat "${WSL_PATH} docker logout"
        }
    }
}