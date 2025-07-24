#!/usr/bin/env bash
set -euo pipefail

# Get the latest short Git commit hash
GIT_COMMIT=$(git rev-parse --short HEAD)

# DockerHub image name (replace with your real DockerHub username if different)
IMAGE="diyacapg/myapp:$GIT_COMMIT"

echo "[INFO] Building Docker image: $IMAGE"
docker build -t $IMAGE ..

echo "[INFO] Logging in to DockerHub"
docker login

echo "[INFO] Pushing Docker image to DockerHub"
docker push $IMAGE

echo "[SUCCESS] Docker image pushed: $IMAGE"
