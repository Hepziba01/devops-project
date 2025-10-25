#!/bin/bash
    
# Load environment variables (passed from Jenkins)
DOCKER_USER=$1
DOCKER_PASS=$2
DOCKERHUB_USER=$3
IMAGE_NAME=$4  # Now receiving the full image name as the 4th argument


# --- 1. Build Docker Image ---
echo "Starting Docker Build for $IMAGE_NAME"
# The . at the end tells Docker to build from the current directory
docker build -t "$IMAGE_NAME" .

if [ $? -ne 0 ]; then
    echo "Docker Build FAILED. Aborting deployment."
    exit 1
fi

# --- 2. Push to Docker Hub ---
echo "Logging into Docker Hub..."
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

echo "Pushing image..."
docker push "$IMAGE_NAME"

if [ $? -ne 0 ]; then
    echo "Docker Push FAILED. Check credentials/network. Aborting."
    exit 1
fi

# --- 3. Deploy with Ansible ---
echo "Executing Ansible Deployment..."
# The -i inventory flag specifies the target list
ansible-playbook playbook.yml -i inventory

# --- 4. Cleanup ---
docker logout
echo "Deployment script finished successfully."