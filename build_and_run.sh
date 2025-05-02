#!/bin/bash

# Define variables
IMAGE_NAME="ollama-gradio"
CONTAINER_NAME="ollama-gradio-app"
VOLUME_NAME="ollama_models"
GRADIO_PORT=7860
OLLAMA_PORT=11434
USE_GPU=${USE_GPU:-1}  # 0 to disable GPU

# 0. Check environment
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker not found in PATH. Please install Docker and add it to your PATH."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "[ERROR] Docker daemon is not running."
    exit 1
fi

# 1. Check if image exists, build if not
echo "[INFO] Checking for Docker image $IMAGE_NAME..."
if ! docker images --format "{{.Repository}}" | grep -q "^${IMAGE_NAME}$"; then
    echo "[INFO] Image not found. Building image $IMAGE_NAME..."
    docker build -t "$IMAGE_NAME" . || {
        echo "[ERROR] Failed to build image."
        exit 1
    }
else
    echo "[INFO] Image $IMAGE_NAME already exists."
    read -p "Do you want to rebuild the image and container? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "[INFO] Rebuilding image..."
        docker build -t "$IMAGE_NAME" . || {
            echo "[ERROR] Failed to build image."
            exit 1
        }
        
        echo "[INFO] Checking for existing container $CONTAINER_NAME..."
        if docker inspect "$CONTAINER_NAME" &> /dev/null; then
            echo "[INFO] Removing existing container..."
            docker rm -f "$CONTAINER_NAME" || {
                echo "[ERROR] Failed to remove container."
                exit 1
            }
        else
            echo "[INFO] No existing container found."
        fi
    fi
fi

# 2. Check if volume exists, create if not
echo "[INFO] Checking for Docker volume $VOLUME_NAME..."
if ! docker volume inspect "$VOLUME_NAME" &> /dev/null; then
    echo "[INFO] Volume not found. Creating volume $VOLUME_NAME..."
    docker volume create "$VOLUME_NAME" || {
        echo "[ERROR] Failed to create volume."
        exit 1
    }
fi

# 3. Check if container exists, create if not, start if stopped
echo "[INFO] Checking for Docker container $CONTAINER_NAME..."
if ! docker inspect "$CONTAINER_NAME" &> /dev/null; then
    echo "[INFO] Container not found. Creating new container..."
    echo [INFO] Checking for GPU support...
    GPU_FLAG=""
    if [ "$USE_GPU" -eq 1 ]; then
        if docker info --format '{{json .Runtimes}}' | grep -q nvidia; then
            GPU_FLAG="--gpus all"
            echo "[INFO] GPU acceleration enabled (NVIDIA detected)."
        else
            echo "[WARNING] GPU requested but no NVIDIA runtime available - falling back to CPU."
        fi
    else
        echo "[INFO] Running in CPU mode."
    fi

    docker run -d \
        $GPU_FLAG \
        -p "$GRADIO_PORT":7860 \
        -p "$OLLAMA_PORT":11434 \
        -v "$VOLUME_NAME":/root/.ollama \
        --name "$CONTAINER_NAME" \
        "$IMAGE_NAME" || {
        echo "[ERROR] Failed to start container."
        exit 1
    }
else
    echo "[INFO] Container $CONTAINER_NAME already exists."
    if docker ps --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
        echo "[INFO] Container is already running."
    else
        echo "[INFO] Starting existing container..."
        if ! docker start "$CONTAINER_NAME"; then
            echo "[ERROR] Failed to start container."
            exit 1
        fi
    fi
fi

# 4. Display deployment information
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

# 5. Auto-open browser (optional)
# if command -v xdg-open >/dev/null; then
#   sleep 5
#   xdg-open "http://localhost:$GRADIO_PORT" &>/dev/null &
# elif command -v open >/dev/null; then
#   sleep 5
#   open "http://localhost:$GRADIO_PORT" &>/dev/null &
# fi

exec bash