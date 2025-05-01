# Ollama + Gradio + LangChain (Updated Integration Guide)

> This guide documents the updated setup for running an all-in-one Docker container with Ollama (LLM backend), Gradio (frontend), and enabling interaction from the host machine via LangChain.

---

## 🔍 Project Overview

This project sets up a single Docker container that runs:
- **Ollama model server** (LLM backend)
- **Gradio web interface** (chat frontend)

And now additionally supports:
- **LangChain on the host machine** calling the containerized Ollama via HTTP API.

---

## 📅 Updated Goals

- Build a self-contained Docker image running both frontend and backend.
- Enable host-based Python scripts (e.g., using LangChain) to interact with Ollama.
- Ensure proper port binding and API accessibility.

---

## 📁 Project Structure

```
ollama_gradio_container/
├── Dockerfile         # Builds the base image
├── start.sh           # Starts Ollama and Gradio
├── gradio_app.py      # Gradio interface with chat UI
├── requirements.txt   # Python dependencies
├── docker-compose.yml # Orchestration and networking config
```

---

## 🧪 Dockerfile Highlights

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl sudo python3 python3-pip git wget

RUN curl -fsSL https://ollama.com/install.sh | sh

COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

WORKDIR /app
COPY gradio_app.py /app/
COPY start.sh /app/
RUN chmod +x /app/start.sh

EXPOSE 7860   # Gradio
EXPOSE 11434  # Ollama

CMD ["/app/start.sh"]
```

---

## 🔧 start.sh (Updated)

```bash
#!/bin/bash

# Enable Ollama to listen on all interfaces
OLLAMA_HOST=0.0.0.0 ollama serve &

# Wait for the Ollama API to become ready
until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "Waiting for Ollama API..."
  sleep 2
done

ollama pull llama2
ollama run llama2 &

sleep 10
python3 /app/gradio_app.py
```

---

## 🤝 docker-compose.yml (Updated)

```yaml
version: '3.8'
services:
  ollama-gradio-app:
    build: .
    container_name: ollama-gradio
    ports:
      - "7860:7860"
      - "11434:11434"
    volumes:
      - ~/.ollama:/root/.ollama
    environment:
      - OLLAMA_HOST=0.0.0.0
    stdin_open: true
    tty: true
```

---

## 🌎 Access

- Gradio UI: http://localhost:7860
- Ollama API (from host): http://localhost:11434/api/tags

You can verify API accessibility with:
```bash
curl http://localhost:11434/api/tags
```

---

## 📄 LangChain Integration from Host

Make sure you install the latest LangChain Ollama integration on your host:

```bash
pip install -U langchain langchain-ollama
```

### Example Python Code:
```python
from langchain_ollama import ChatOllama

llm = ChatOllama(model="llama2", base_url="http://localhost:11434")
response = llm.invoke("你好，请介绍一下你是谁")
print(response.content)
```

If everything is set up correctly, this script will communicate with the LLM model running in the Docker container.

---

## 🎓 Technical Insight: Listening vs Connection

- **Port Mapping (`11434:11434`)** bridges host to container.
- **Listening on `0.0.0.0`** allows the container to accept requests from host.
- **`127.0.0.1` only** listens inside container, host won't reach it even with port mapping.

Always make sure Ollama is set to:
```bash
OLLAMA_HOST=0.0.0.0
```
To allow outside access.

---

## 🚀 What’s Next

- Add streaming token support
- Integrate LangChain chains/tools in the container
- Add file upload (PDFs, etc.)
- Use `docker-compose` with more services (e.g. DB + LLM + frontend)

---

## 📄 Reference Commands

```bash
# Build and run container with updated config
docker compose up --build

# From host: test API is working
curl http://localhost:11434/api/tags

# From host: run LangChain client script
python3 langchain_client.py
```

---

Now you have a unified system: containerized Ollama + Gradio frontend + external LangChain client all working together ✨

