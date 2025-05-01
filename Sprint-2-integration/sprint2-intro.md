
# Sprint 2 Discussion Summary: Ollama + Gradio + LangChain Integration

## 🔍 Current Status Recap

| Component       | Status                      | Notes |
|-----------------|------------------------------|-------|
| Ollama Server   | ✅ Running inside container | via `start.sh`, port 11434 exposed |
| Gradio Frontend | ✅ Running inside container | Communicates with Ollama |
| LangChain (host) | ✅ Host-based Python script connected to container | Working via HTTP calls |
| LangChain (container) | ❌ Not yet integrated inside container | Planned for Sprint 2 |

## 📅 Sprint 2 Goal

> **Objective**: Integrate LangChain into the existing Ollama + Gradio container, creating a fully unified, self-contained AI application.

## 👥 New Epic and Stories for Sprint 2

### Epic
> Full integration of LangChain into the unified Docker container alongside Ollama and Gradio.

### Stories

| Story ID | Story Title                                   | Purpose |
|----------|------------------------------------------------|---------|
| S2-1     | Add LangChain runtime to container             | Full backend integration |
| S2-2     | Update `start.sh` to sequentially launch services | Manage startup order |
| S2-3     | Refactor Gradio to interact with LangChain    | Clearer data flow |
| S2-4     | End-to-end system testing                     | Validate communication |
| S2-5     | Update project README                         | Document new architecture |

## 📄 Issues Drafted

- **Add LangChain runtime to existing Ollama-Gradio container**
- **Update `start.sh` for service health checks and sequential startup**
- **Refactor Gradio frontend to route requests through LangChain**
- **Internal API routing and port management cleanup**
- **Documentation update with new diagrams and instructions**

## 🌐 Internal Communication Flow (Targeted Design)

```plaintext
[ Gradio Frontend ]
    |
    | (send prompt input)
    v
[ LangChain Logic Layer ]
    |
    | (POST to Ollama API localhost:11434)
    v
[ Ollama Model Backend ]
    |
    | (generate response)
    v
[ LangChain parses output ]
    |
    | (format for Gradio)
    v
[ Gradio displays final result ]
```

All communication internal to container via localhost.

## 📈 Risk Log

| ID  | Risk Description                                   | Impact Level | Likelihood | Mitigation Strategy |
|-----|----------------------------------------------------|--------------|------------|----------------------|
| R1  | LangChain dependency conflicts inside container   | High         | Medium     | Version pinning and isolated testing |
| R2  | Service startup race condition between components | Medium       | High       | Health checks and wait loops in start.sh |
| R3  | Gradio fails to connect to LangChain API correctly | High         | Medium     | Thorough end-to-end testing |
| R4  | Container size and build time increase             | Medium       | Low        | Docker optimization, layer caching |

## 🚀 Immediate Next Steps

1. Modify `Dockerfile` and `requirements.txt` to add LangChain.
2. Update `start.sh` to sequentially launch Ollama, LangChain logic server (if any), and Gradio.
3. Refactor Gradio frontend to route prompts via LangChain.
4. Confirm internal localhost-based API calls function correctly.
5. Update README with unified architecture and usage instructions.

---

> ✨ With these tasks, Sprint 2 will deliver a complete one-container solution that runs Ollama, LangChain, and Gradio seamlessly together!
