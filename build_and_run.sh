#!/bin/bash

# Check environment
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker not found in PATH. Please install Docker and add it to your PATH."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "[ERROR] Docker daemon is not running."
    exit 1
fi

# Load .env variables
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "[WARNING] .env file not found. Using default variables."
fi

# Check GPU support
echo "[INFO] Checking for GPU support..."
if [ "$DOCKER_RUNTIME" = "nvidia" ]; then
    if docker info --format '{{json .Runtimes}}' | grep -q nvidia; then
        echo "[INFO] GPU acceleration enabled (NVIDIA detected)."
    else
        export DOCKER_RUNTIME = "runc"
        echo "[WARNING] GPU requested but no NVIDIA runtime available - falling back to CPU."
    fi
else
    echo "[INFO] Running in CPU mode."
    export DOCKER_RUNTIME = "runc"
fi

# Docker compose
if ! docker-compose up -d; then
    echo "[ERROR] docker-compose failed."
    exit 1
fi

# Display deployment information
cat <<EOF

[SUCCESS] Deployment completed
========================
Gradio Access URL:   http://localhost:$GRADIO_PORT
Ollama API URL:      http://localhost:$OLLAMA_PORT
========================
Management Commands:
View logs:          docker logs -f $CONTAINER_NAME
Enter container:    docker exec -it $CONTAINER_NAME bash
Stop container:     docker stop $CONTAINER_NAME
Remove container:   docker rm -f $CONTAINER_NAME
Remove image:       docker rmi $IMAGE_NAME
Inspect volume:     docker volume inspect $VOLUME_NAME
EOF

# Auto-open browser (optional)
# if command -v xdg-open >/dev/null; then
#   sleep 5
#   xdg-open "http://localhost:$GRADIO_PORT" &>/dev/null &
# elif command -v open >/dev/null; then
#   sleep 5
#   open "http://localhost:$GRADIO_PORT" &>/dev/null &
# fi

exec bash