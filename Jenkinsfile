pipeline {
    agent any // Run on any available Jenkins agent

    stages {
        stage('1. Checkout from GitHub') {
            steps {
                // This pulls your code from the 'main' branch of your repo
                git branch: 'main', url: 'https://github.com/Hepziba01/devops-project.git'
            }
        }

        stage('2. Build Docker Image') {
            steps {
                script {
                    // CORRECTED TO 'bat'
                    bat 'docker build -t my-web-app .'
                }
            }
        }
        
        stage('3. (Optional) Push to Docker Hub') {
            steps {
                // Change the 'echo' command to 'bat' as well
                bat 'echo Skipping Docker Hub push for now.'
            }
        }
        
        stage('4. (Future) Deploy with Ansible') {
            steps {
                // Use 'wsl' prefix as planned, but call it with 'bat'
                bat 'wsl.exe echo Skipping Ansible deployment for now.' 
            }
        }