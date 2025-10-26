pipeline {
    agent any

    environment {
        // --- Core Variables ---
        GITHUB_USER = 'Hepziba01'
        DOCKERHUB_USER = 'hepziba'
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
        WSL_PATH = 'C:/Windows/System32/wsl.exe'
        
        // --- Testing Variables ---
        TEST_CONTAINER_NAME = "test-container-${BUILD_NUMBER}" // Unique name for test container
    }

    stages {
        // STAGE 1: Checkout and Prepare Script
        stage('1. Checkout and Setup') {
            steps {
                echo "Pulling code from ${env.GITHUB_USER}/devops-project"
                checkout scm 
                
                // Fixes line ending issue on checkout
                echo "Converting deploy.sh line endings to Unix format"
                powershell "${env.WSL_PATH} dos2unix deploy.sh" 
            }
        }

        // STAGE 2: Build and Automated Test (New for Excellent Score)
        stage('2. Build and Automated Test') {
            steps {
                script {
                    echo "--- 2a. Building Image ---"
                    // Build the final image tag we will push
                    powershell "${env.WSL_PATH} sudo docker build -t ${IMAGE_NAME} ." 
                    
                    echo "--- 2b. Starting Container for Test ---"
                    // Map port 8081 for external test
                    powershell "${env.WSL_PATH} sudo docker run -d --rm -p 8081:3000 --name ${TEST_CONTAINER_NAME} ${IMAGE_NAME}"
                    
                    // Wait for server to start
                    powershell 'Start-Sleep -Seconds 5' 
                    
                    echo "--- 2c. Running Health Check (curl) ---"
                    // Use curl inside WSL to check the host on the mapped port 8081
                    powershell "${env.WSL_PATH} curl --fail --silent --show-error http://localhost:8081" 
                    echo "Test successful: Web app is responsive."
                }
            }
            post {
                // Always stop and remove the test container
                always {
                    echo "--- Stopping and removing test container ---"
                    powershell "${env.WSL_PATH} sudo docker stop ${TEST_CONTAINER_NAME} || true"
                    powershell "${env.WSL_PATH} sudo docker rm ${TEST_CONTAINER_NAME} || true"
                }
            }
        }

        // STAGE 3: Push and Final Deploy
        stage('3. Push and Final Deploy') { 
            steps {
                script {
                    echo "--- 3a. Logging in and Pushing Tested Image ---"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        powershell "${env.WSL_PATH} sudo docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        powershell "${env.WSL_PATH} sudo docker push ${IMAGE_NAME}"
                        
                        echo "--- 3b. Executing Ansible Deployment ---"
                        // Execute the deployment script
                        powershell "${env.WSL_PATH} bash ./deploy.sh ${DOCKER_USER} ${DOCKER_PASS} ${DOCKERHUB_USER} ${IMAGE_NAME}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Final cleanup is handled here
            powershell "${env.WSL_PATH} sudo docker logout || true"
            echo "CI/CD Pipeline Completed. Final status is ${currentBuild.result}"
        }
    }
}