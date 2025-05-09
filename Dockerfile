FROM nvidia/cuda:12.2.2-base-ubuntu22.04

# Set environment variables
ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    OLLAMA_MODELS=/root/.ollama
VOLUME $OLLAMA_MODELS

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    python3 \
    python3-pip \
    git \
    wget \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Deepthink App
WORKDIR /app
COPY container/app/ /app/

# Install Python dependencies
COPY container/requirements.txt .
RUN pip3 install --cache-dir=/root/.cache/pip -r requirements.txt && rm requirements.txt

# Supervisor configuration
COPY container/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /var/run && \
    chmod 755 /var/log/supervisor /var/run && \
    chown -R root:root /var/log/supervisor /var/run

# Expose ports
# Gradio
EXPOSE 7860
# Ollama
EXPOSE 11434
# Langchain
EXPOSE 8000

# Health check for Gradio app
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
    CMD curl -f http://localhost:11434/api/tags || exit 1

# Entry point
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
