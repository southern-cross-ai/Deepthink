FROM ubuntu:22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    python3 \
    python3-pip \
    git \
    wget

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

# Copy Gradio App and startup script
WORKDIR /app
COPY gradio_app.py /app/
COPY start.sh /app/

# Expose ports
EXPOSE 7860
EXPOSE 11434

# Entry point
CMD ["/app/start.sh"]