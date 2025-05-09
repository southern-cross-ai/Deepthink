#!/bin/bash

# Stop the script if any command fails
trap 'echo "[INFO] Caught SIGTERM, shutting down..."; kill 0; wait' SIGTERM


# Start the Ollama service (listening on all interfaces)
OLLAMA_HOST=0.0.0.0 ollama serve &

# Wait for the Ollama REST API to become available
echo "[INFO] Waiting for Ollama API to be ready..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "[INFO] Ollama not ready yet. Retrying..."
  sleep 2
done
echo "[INFO] Ollama API is ready."

available_models=("llama3.2:3b" "mistral:7b" "gemma3:4b" "phi3:3.8b")

# Check if models are already pulled
echo "[INFO] Starting to pull models: ${available_models[*]}"
for model in "${available_models[@]}"; do
  echo "[INFO] Pulling model: $model"
  if ! ollama pull "$model"; then
    echo "[ERROR] Failed to pull model: $model"
    exit 1
  fi
done
echo "[INFO] All models pulled successfully."

# Check if models are available
for model in "${available_models[@]}"; do
  echo "[INFO] Starting model: $model"
  # Run the command in a subshell and send to background
  (
    if ! ollama run "$model"; then
      echo "[ERROR] Failed to start model: $model"
      exit 1
    fi
  ) &
done
echo "[INFO] All models started successfully."

# Optionally wait to ensure the model is fully initialized
sleep 10

# Launch Langchain API backend
echo "[INFO] Starting Langchain API..."
python3 /app/langchain_api.py &

# Start the Gradio frontend
echo "[INFO] Starting Gradio app..."
python3 /app/gradio_app.py
