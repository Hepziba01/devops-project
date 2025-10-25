pipeline {
    agent any

    stages {
        stage('1. Checkout from GitHub') {
            steps {
                // This connects to the SCM you configured in the job settings
                checkout scm 
            }
        }

        stage('2. Build, Push (or Skip) & Deployment Prep') {
            steps {
                // We use bat for all commands because Jenkins is running natively on Windows.
                bat '''
                    REM The following commands must be run as a single block on Windows
                    
                    REM 2a. Build Docker Image
                    docker build -t my-web-app .
                    
                    REM 2b. Skip Push for now
                    echo "Skipping Docker Hub push for now."
                    
                    REM 2c. Skip Ansible deployment for now
                    wsl.exe echo "Skipping Ansible deployment for now."
                '''
            }
        }
        
        stage('3. Docker Hub & Ansible (Will be skipped)') {
             steps {
                 echo 'This stage will be skipped as the execution is bundled in Stage 2'
             }
        }
    }
}