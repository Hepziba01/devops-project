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
                    // This runs the same 'docker build' command you ran locally
                    sh 'docker build -t my-web-app .'
                }
            }
        }

        stage('3. (Optional) Push to Docker Hub') {
            steps {
                // We will add this later.
                echo 'Skipping Docker Hub push for now.'
            }
        }

        stage('4. (Future) Deploy with Ansible') {
            steps {
                // We will add this in Phase 4.
                echo 'Skipping Ansible deployment for now.'
            }
        }
    }
}