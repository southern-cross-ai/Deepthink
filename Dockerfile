FROM ubuntu:22.04

# 1.安装依赖，安装服务，和下载文件（脚本，前端）
# 2.暴露端口
# 3.执行下载的脚本-在容器内执行（启用服务ollama，加载下载模型）

# 安装基本依赖
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    python3 \
    python3-pip \
    git \
    wget

# 安装 Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# 安装 Python 依赖
COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

# 拷贝 Gradio App 和启动脚本
WORKDIR /app
COPY gradio_app.py /app/
COPY start.sh /app/
COPY langchain_api.py /app/
RUN chmod +x /app/start.sh

# 暴露端口
EXPOSE 7860
EXPOSE 11434

# 入口
CMD ["/app/start.sh"]