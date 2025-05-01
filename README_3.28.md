# Ollama + Gradio All-in-One Container (English Version)

> A Docker-based project that runs both the Ollama LLM backend and a Gradio frontend UI in a single container. Designed for easy local development and testing of LLMs with web access.

---

## 🔍 Project Overview

### Goal
- Build a **custom Docker image** that launches:
  - **Ollama model server** (LLM inference backend)
  - **Gradio-based web interface** (chat frontend)
- Enable real-time local interaction with LLMs without relying on external APIs
- Streamline development workflow for prototyping AI apps

---

## 📁 Project Structure

```
ollama_gradio_container/
├── Dockerfile         # Image build script
├── start.sh           # Shell script to start Ollama & Gradio
├── gradio_app.py      # Gradio frontend with Ollama API integration
├── requirements.txt   # Python dependencies
```

---

## 🧠 Design Principles

| Principle           | Description- |
|---------------------|-------------|
| **Single container**| Everything (LLM + frontend) runs in one image |
| **REST API integration** | Gradio connects to Ollama via HTTP requests |
| **Robust startup**   | Uses `curl` to wait for Ollama to become ready |
 
---

## 📃 File Breakdown

### 1. `Dockerfile`

Builds a Ubuntu-based image with Python and Ollama installed.

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    python3 \
    python3-pip \
    git \
    wget

RUN curl -fsSL https://ollama.com/install.sh | sh

COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

WORKDIR /app
COPY gradio_app.py /app/
COPY start.sh /app/
RUN chmod +x /app/start.sh

EXPOSE 7860   # Gradio UI
EXPOSE 11434  # Ollama API

CMD ["/app/start.sh"]
```

---

### 2. `start.sh`

Launches Ollama in the background, waits until API is ready, then launches Gradio.

```bash
#!/bin/bash

ollama serve &

# Wait until Ollama API is reachable
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

### 3. `gradio_app.py`

Defines the Gradio UI and integrates with the Ollama REST API.

```python
import gradio as gr
import requests

def chat_with_ollama(prompt, history):
    if not isinstance(history, list):
        history = []

    messages = []
    for user_msg, bot_msg in history:
        messages.append({"role": "user", "content": user_msg})
        messages.append({"role": "assistant", "content": bot_msg})
    messages.append({"role": "user", "content": prompt})

    response = requests.post(
        "http://localhost:11434/api/chat",
        json={"model": "llama2", "messages": messages, "stream": False}
    )

    try:
        reply = response.json()["message"]["content"]
    except Exception as e:
        reply = f"[Error] {e}\nRaw response:\n{response.text}"

    history.append((prompt, reply))
    return history, history

iface = gr.Interface(
    fn=chat_with_ollama,
    inputs=[gr.Textbox(label="Your message"), gr.State([])],
    outputs=[gr.Chatbot(), gr.State([])],
    title="Ollama + Gradio in One Container"
)

iface.launch(server_name="0.0.0.0", server_port=7860)
```

---

### 4. `requirements.txt`

```txt
gradio
requests
```
Python packages used by the Gradio frontend and API client.

---

## 🌐 Usage Instructions

### Build the image
```bash
docker build -t ollama-gradio-app .
```

### Run the container (with GPU & volume)
```bash
docker run --gpus all \
  -p 7860:7860 \
  -p 11434:11434 \
  -v ~/.ollama:/root/.ollama \
  ollama-gradio-app
```
> Remove `--gpus all` if you're not using GPU

---

## 🔗 Architecture Flow

```
[User] --> Gradio (gradio_app.py) --> [POST /api/chat] --> Ollama --> LLM Response
```

---

## 🚀 Troubleshooting

| Step       | Problem                     | Solution |
|------------|-----------------------------|----------|
| Build      | Slow / failed downloads     | Retry or change mirror |
| Run        | Port already in use         | Free port or change mapping |
| Chat       | 404 or `KeyError: 'message'`| Ollama not ready yet; add wait/check |

---

## 🛠️ Next Steps

- Add **streaming support** for real-time token output
- Allow **file upload** (PDF summarization, etc.)
- Integrate **LangChain**, **FastAPI**, or **llama-index**
- Use **docker-compose** to manage future services (e.g. DB + Ollama + UI)

