#!/bin/bash
    
# Load arguments passed from Jenkins: $1=DOCKER_USER, $2=DOCKER_PASS, etc.
DOCKER_USER=$1
DOCKER_PASS=$2
DOCKERHUB_USER=$3
IMAGE_NAME=$4 

# --- 1. Build Docker Image ---
echo "Starting Docker Build for $IMAGE_NAME"
# Use sudo to ensure required permissions are available in WSL
sudo docker build -t "$IMAGE_NAME" .

if [ $? -ne 0 ]; then
    echo "Docker Build FAILED. Aborting deployment."
    exit 1
fi

# --- 2. Push to Docker Hub ---
echo "Logging into Docker Hub..."
# Use sudo for docker login and use --password-stdin for security
echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin

echo "Pushing image..."
sudo docker push "$IMAGE_NAME"

if [ $? -ne 0 ]; then
    echo "Docker Push FAILED. Check credentials/network. Aborting."
    exit 1
fi

# --- 3. Deploy with Ansible ---
echo "Executing Ansible Deployment..."
# Execute playbook with sudo to ensure it can perform root tasks on the target server
sudo ansible-playbook playbook.yml -i inventory

# --- 4. Cleanup ---
sudo docker logout
echo "Deployment script finished successfully."