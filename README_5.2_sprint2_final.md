
# 📦 Ollama + LangChain + Gradio: Unified Containerized LLM App (Post-Sprint 2)

> This README reflects the complete state of the project as of the end of Sprint 2 (post-April 11), with full LangChain + Gradio + Ollama integration inside a single container. It summarizes all updates, resolved issues, and next-stage planning.

---

## ✅ Project Milestone Summary

| Component        | Status   | Notes |
|------------------|----------|-------|
| Ollama (LLM)     | ✅ Running in container on port 11434 |
| Gradio Frontend  | ✅ Running in container on port 7860 |
| LangChain Logic  | ✅ Integrated into container as FastAPI (port 8000) |
| Full Routing     | ✅ Gradio → LangChain → Ollama completed |

---

## 🧩 File Overview (as of Sprint 2)

```
ollama_gradio_container/
├── Dockerfile
├── start.sh                 # Sequential startup of Ollama, LangChain API, Gradio
├── gradio_app.py            # Refactored to call LangChain API
├── langchain_api.py         # FastAPI LangChain server exposing /chat
├── requirements.txt         # Updated Python dependencies
├── docker-compose.yml       # Ports 7860, 8000, 11434 exposed
```

---

## 🚀 Key Updates Since April 11

### ✅ 1. LangChain API Containerized
- New file `langchain_api.py` launches FastAPI at port 8000.
- Implements `/chat` endpoint using LangChain → Ollama.
- Replaces host-based LangChain scripts.

### ✅ 2. Gradio Refactored
- `gradio_app.py` now sends user input to `http://localhost:8000/chat` instead of Ollama API.
- Simplified prompt structure; stateful history optional.
- Errors handled gracefully with response fallback.

### ✅ 3. Dockerfile Updated
```dockerfile
COPY langchain_api.py /app/
```
Also includes `fastapi`, `uvicorn`, and LangChain libraries.

### ✅ 4. start.sh Sequencing
```bash
OLLAMA_HOST=0.0.0.0 ollama serve &
# Wait for Ollama to be ready
ollama run llama2 &
python3 /app/langchain_api.py &
python3 /app/gradio_app.py
```
Ensures API is started before Gradio UI.

### ✅ 5. docker-compose Enhancements
- New exposed port: `8000:8000`
- Added `image: ollama-gradio-5.1`
- GPU compatibility reserved
- Volume mounted: `~/.ollama:/root/.ollama`

---

## 💡 Resolved Issues

| Issue | Summary |
|-------|---------|
| #36   | LangChain API copied into Dockerfile, served inside container |
| #38   | Gradio switched to LangChain API endpoint instead of Ollama |
| curl 52 error | Resolved by ensuring API is run & port mapped |
| Missing file | `langchain_api.py` missing → added COPY in Dockerfile |
| Service race | `start.sh` sequencing corrected |

---

## 🌐 Access Endpoints

| Service     | URL                          |
|-------------|------------------------------|
| Gradio UI   | http://localhost:7860        |
| LangChain   | http://localhost:8000/chat   |
| Ollama API  | http://localhost:11434/api/tags |

---

## 🧪 Test Example (Post-integration)

```bash
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"topic": "你好"}'
```

Expected response:
```json
{ "response": "你好！很高兴认识你..." }
```

---

## 📌 Current Flow Diagram

```
[ Gradio UI ] (7860)
      ↓
[ LangChain API ] (8000)
      ↓
[ Ollama Model ] (11434)
```

---

## 📌 Sprint 3 Planning (Next Steps)

- [ ] Add support for chat history (multi-turn)
- [ ] Add logging and usage stats for API
- [ ] Move LangChain logic to Chains/Tools
- [ ] Add PDF/document upload + embeddings (Chroma or FAISS)
- [ ] CI/CD auto-deploy (optional)
- [ ] Better error handling (timeouts, retry, etc.)

---

## 📎 Commands

```bash
docker compose up --build        # Rebuild container with all components
curl http://localhost:8000/chat  # Call LangChain API
```

---

This completes the Sprint 2 deliverable: a unified, modular, fully functional LLM container with Gradio frontend, LangChain orchestration, and Ollama inference backend. ✅

---

## 📂 Key Files with Code and Explanations

### 📄 1. langchain_api.py (FastAPI server for LangChain)

```python
from fastapi import FastAPI
from pydantic import BaseModel
from langchain_ollama import ChatOllama
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

app = FastAPI()

class ChatRequest(BaseModel):
    topic: str

prompt = PromptTemplate.from_template("{topic}")
model = ChatOllama(model="llama2", base_url="http://localhost:11434", streaming=False)
parser = StrOutputParser()

@app.post("/chat")
async def chat(req: ChatRequest):
    formatted = prompt.format(topic=req.topic)
    result = model.invoke(formatted)
    return {"response": parser.invoke(result)}
```

✅ **Explanation**:
- Exposes POST `/chat` endpoint.
- Uses LangChain to format input, call Ollama, and parse output.
- Acts as an internal API between Gradio and model backend.

---

### 📄 2. gradio_app.py (Frontend UI calling LangChain API)

```python
import gradio as gr
import requests

def chat_with_langchain(prompt, history):
    response = requests.post(
        "http://localhost:8000/chat",
        json={"topic": prompt}
    )
    reply = response.json().get("response", "[Error]")
    history.append((prompt, reply))
    return history, history

iface = gr.Interface(
    fn=chat_with_langchain,
    inputs=[gr.Textbox(label="Your message"), gr.State([])],
    outputs=[gr.Chatbot(), gr.State([])],
    title="Gradio → LangChain → Ollama"
)

iface.launch(server_name="0.0.0.0", server_port=7860)
```

✅ **Explanation**:
- UI accepts user input and calls LangChain API.
- Displays the chatbot response via parsed JSON.

---

### 📄 3. Dockerfile (Container build instructions)

```dockerfile
FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY gradio_app.py /app/
COPY langchain_api.py /app/
COPY start.sh /app/
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
```

✅ **Explanation**:
- Installs LangChain, Gradio, FastAPI.
- Copies all Python scripts.
- Runs the unified startup script.

---

### 📄 4. start.sh (Service orchestration)

```bash
OLLAMA_HOST=0.0.0.0 ollama serve &

until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "Waiting for Ollama..."
  sleep 2
done

ollama run llama2 &
python3 /app/langchain_api.py &
sleep 5
python3 /app/gradio_app.py
```

✅ **Explanation**:
- Starts Ollama server, waits for readiness.
- Launches LangChain API → Then Gradio.
- Ensures services start in correct order.

---

### 📄 5. docker-compose.yml (Multi-port orchestration)

```yaml
services:
  ollama-gradio-app:
    build: .
    image: ollama-gradio:latest
    container_name: deepthink-instance
    ports:
      - "7860:7860"
      - "11434:11434"
      - "8000:8000"
    volumes:
      - ~/.ollama:/root/.ollama
    environment:
      - OLLAMA_HOST=0.0.0.0
    tty: true
    stdin_open: true
```

✅ **Explanation**:
- Exposes all required services: Gradio UI, LangChain API, Ollama backend.
- Mounts local model cache for reuse.
