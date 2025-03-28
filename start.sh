#!/bin/bash

# Start Ollama service
ollama serve &

# Wait for Ollama's REST API to be ready
echo "Waiting for Ollama API to be ready..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "Still waiting for Ollama..."
  sleep 2
done

# Download and load the model
ollama pull llama2
ollama run llama2 &

# Wait for the model to be ready (can conservatively sleep for a bit)
sleep 10

# Start Gradio frontend
python3 /app/gradio_app.py