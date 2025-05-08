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

# Download and run the llama2 model
echo "[INFO] Pulling llama2 model..."
if ! ollama pull llama2; then
  echo "[ERROR] Failed to pull llama2 model."
  exit 1
fi

echo "[INFO] Starting llama2 model..."
ollama run llama2 &

# Optionally wait to ensure the model is fully initialized
sleep 10

# Launch Langchain API backend
echo "[INFO] Starting Langchain API..."
python3 /app/langchain_api.py &

# Start the Gradio frontend
echo "[INFO] Starting Gradio app..."
python3 /app/gradio_app.py
