#!/bin/bash
set -euo pipefail

echo "[INFO] Building Docker image: diyacapg/myapp:$(git rev-parse --short HEAD)"
docker build -t diyacapg/myapp:$(git rev-parse --short HEAD) .
docker tag diyacapg/myapp:$(git rev-parse --short HEAD) diyacapg/myapp:latest

echo "[INFO] Logging in to DockerHub"
echo "seS*68SeiRYSL*p" | docker login -u "diyacapg" --password-stdin

echo "[INFO] Pushing Docker image with tag $(git rev-parse --short HEAD)"
docker push diyacapg/myapp:$(git rev-parse --short HEAD)
docker push diyacapg/myapp:latest

echo "[SUCCESS] Docker image pushed!"

