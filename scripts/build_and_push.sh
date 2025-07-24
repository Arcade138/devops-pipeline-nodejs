#!/usr/bin/env bash
set -euo pipefail

# Ensure GIT_COMMIT is available
GIT_COMMIT=$(git rev-parse --short HEAD)
IMAGE="diyaCapg/myapp:$GIT_COMMIT"

echo "[INFO] Building Docker image: $IMAGE"
docker build -t $IMAGE ..

echo "[INFO] Pushing Docker image to DockerHub"
docker push $IMAGE

echo "[SUCCESS] Image pushed: $IMAGE"
