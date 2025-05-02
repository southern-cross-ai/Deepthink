#!/bin/bash

# Define variables
IMAGE_NAME="ollama-gradio"
CONTAINER_NAME="ollama-gradio-app"
VOLUME_NAME="ollama_models"
GRADIO_PORT=7860
OLLAMA_PORT=11434
USE_GPU=${USE_GPU:-1}  # Default to GPU enabled

# 0. Check if container already exists, if so, start it.
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "[INFO] Container $CONTAINER_NAME is already running"
    else
        echo "[INFO] Starting existing container..."
        docker start $CONTAINER_NAME || {
            echo "[ERROR] Failed to start container"
            exit 1
        }
    fi
    
else
    # 1. Build Docker image
    echo "[INFO] Building Docker image..."
    docker build -t $IMAGE_NAME . || {
        echo "[ERROR] Failed to build image";
        exit 1;
    }

    # 2. Check if volume exists, create if not
    if ! docker volume inspect $VOLUME_NAME &>/dev/null; then
        echo "[INFO] Creating volume: $VOLUME_NAME"
        docker volume create $VOLUME_NAME
    fi

    # 3. Run container
    # GPU Support
    if [ "$USE_GPU" -eq 1 ]; then
        if docker info | grep -q "Runtimes.*nvidia"; then
            GPU_FLAG="--gpus all"
            echo "[INFO] GPU acceleration enabled (NVIDIA detected)"
        else
            GPU_FLAG=""
            USE_GPU=0
            echo "[WARNING] GPU requested but no NVIDIA runtime found - falling back to CPU"
        fi
    else
        GPU_FLAG=""
        echo "[INFO] Running in CPU mode (by request)"
    fi

    echo "[INFO] Starting container..."
    docker run -d \
        $GPU_FLAG \
        -p $GRADIO_PORT:7860 \
        -p $OLLAMA_PORT:11434 \
        -v $VOLUME_NAME:/root/.ollama \
        --name $CONTAINER_NAME \
        $IMAGE_NAME || {
        echo "[ERROR] Failed to start container";
        exit 1;
    }
fi

# 4. Display deployment information
echo ""
echo "[SUCCESS] Deployment completed"
echo "========================"
echo "Gradio Access URL:   http://localhost:$GRADIO_PORT"
echo "Ollama API URL:     http://localhost:$OLLAMA_PORT"
echo "========================"
echo "Management Commands:"
echo "View logs:    docker logs -f $CONTAINER_NAME"
echo "Enter container:    docker exec -it $CONTAINER_NAME bash"
echo "Stop container:    docker stop $CONTAINER_NAME"
echo "Remove container:    docker rm -f $CONTAINER_NAME"
echo "Remove image:    docker rmi $IMAGE_NAME"
echo "Inspect volume:  docker volume inspect $VOLUME_NAME"

# # 5. Auto-open browser (optional)
# sleep 5  # Wait for services to start
# if which xdg-open >/dev/null; then
#     xdg-open "http://localhost:$GRADIO_PORT" >/dev/null 2>&1
# elif which open >/dev/null; then
#     open "http://localhost:$GRADIO_PORT" >/dev/null 2>&1
# fi

exec bash