#!/bin/bash

# 启动 Ollama 服务
OLLAMA_HOST=0.0.0.0 ollama serve &

# 等待 Ollama 的 REST API 正常
echo "Waiting for Ollama API to be ready..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "Still waiting for Ollama..."
  sleep 2
done

# 下载并加载模型
ollama pull llama2
ollama run llama2 &

# 再等待模型就绪（可保守 sleep 一下）
sleep 10

# 启动 Gradio 前端
python3 /app/gradio_app.py