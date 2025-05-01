#!/bin/bash

# 构建镜像
docker build -t ollama-gradio-app .

# 启动容器（后台运行）
docker run -d \
  --name ollama-ui \
  -p 7860:7860 \
  -p 11434:11434 \
  -v ~/.ollama:/root/.ollama \
  ollama-gradio-app

# 等待端口可用
echo "Waiting for Gradio on http://localhost:7860 ..."
while ! nc -z localhost 7860; do
  sleep 1
done

# 自动打开浏览器
xdg-open http://localhost:7860 2>/dev/null || start http://localhost:7860 || open http://localhost:7860
