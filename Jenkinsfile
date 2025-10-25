pipeline {
    agent any

    environment {
        // Your Docker Hub username (must be correct!)
        DOCKERHUB_USER = 'Hepziba01' 
        IMAGE_NAME = "${DOCKERHUB_USER}/devops-project:latest"
    }

    stages {
        stage('1. Checkout from GitHub') {
            steps {
                // Uses the SCM configured in the Jenkins job settings
                checkout scm 
            }
        }

        stage('2. Build and Tag Docker Image (via WSL)') {
            steps {
                // This command tells Windows (bat) to launch the WSL terminal (wsl.exe) 
                // and then run the 'docker build' command inside Linux.
                bat "wsl.exe docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('3. Push to Docker Hub (via WSL)') {
            steps {
                // We are using the credentials you set up previously.
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    // Log in and push commands are run inside WSL.
                    bat "wsl.exe docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                    bat "wsl.exe docker push ${IMAGE_NAME}"
                }
            }
        }

        stage('4. Deploy with Ansible (via WSL)') {
            steps {
                // Runs the Ansible playbook, also fully inside the WSL environment.
                echo 'Starting Ansible deployment...'
                bat 'wsl.exe ansible-playbook playbook.yml -i inventory'
            }
        }
    }

    post {
        always {
            // Clean up: log out of the registry inside WSL
            bat 'wsl.exe docker logout'
        }
    }
}