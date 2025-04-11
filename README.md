# 🌟 DeepThink - A Aouthern Cross AI Team

<div align="center">
  <img src="https://i.imgur.com/GZ7rUqN.gif" width="400"/>
</div>  

## 🎯 Our Mission

DeepThink is an AI-driven research team under Southern Cross AI, focused on building a modular, containerized AI application development platform. Our system is based on Ollama (for running large language models), LangChain (for orchestration), and Gradio (for web-based interaction). We aim to deliver a flexible, cross-platform development pipeline using Docker, enabling users to rapidly prototype and deploy offline AI apps.

<div align="center">
  <img src="https://media.giphy.com/media/QTfX9Ejfra3ZmNxh6B/giphy.gif" width="400"/>
</div>


---

## 🔍 Key Objectives

### 🏗️ **Containerized Development Framework**
- Develop a **custom Docker image** combining Ollama, LangChain, and Gradio.
- Enable local execution of LLMs with modular backend/frontend separation.
- Ensure image is compatible across platforms (x86, ARM).

---

### 🎮 **Pipeline & Interaction Design**
- Implement a **prompt → chain → response** workflow using LangChain.
- Use Gradio to build an **interactive frontend** that starts automatically.
- Support optional modules like document-based Q&A using local knowledge.

---

## 🏗 Implementation Plan

### ✅ Step 1: Foundation Setup & Model Loading
- Create a **multi-stage** Dockerfile with Ollama.
- Integrate **model caching, environment variables**, and **readiness probes**.
- Support both **CPU and GPU** acceleration.

### ✅ Step 2: LangChain Integration
- Install LangChain and implement basic **LLMChain** logic.
- Use **LCEL** and **Jinja2 templates** for structured chaining.
- Add support for **conversation memory, structured outputs**, and **asynchronous tasks**.

### ✅ Step 3: Gradio Interface Development
- Build a **Gradio Blocks**-based UI with real-time chat interaction.
- Include features like **KaTeX rendering, session persistence**, and **light/dark modes**.
- Automatically launch frontend on container startup.

### ✅ Step 4: Deployment and Documentation
- Provide Docker Compose and Kubernetes **deployment scripts**.
- Integrate monitoring tools like **Prometheus** and **OpenTelemetry**.
- Document **APIs, configs, and troubleshooting**.

### ✅ Step 5 (Optional): Knowledge Base Expansion
- Implement **hybrid retrieval** using BM25 + vector similarity.
- Add RAG pipelines with **semantic chunking** and **query rewriting**.
- Support multi-format documents and persistent embeddings.

## 🌍 Why It Matters
By combining cutting-edge open-source tools in a unified platform, DeepThink enables developers to:
- Run LLMs locally with privacy and speed.
- Rapidly prototype AI workflows with reusable components.
- Easily adapt the stack for future extensions like voice input/output and mobile deployment.

<audio controls>
  <source src="https://files.catbox.moe/amo4p6.mp3" type="audio/mpeg">
</audio>

🚀 *Join us as we shape the future of modular, local-first AI development!* 🎮

---

## 📄 Additional Project Documents

You can find our supporting files and documentation here:
- 🧩 [Statement of Work (Docs)](https://docs.google.com/document/d/1WI57MfdQCkO5DCql64tNLIItVtlABv6D/edit?usp=sharing&ouid=111345095007819589151&rtpof=true&sd=true)
- 🧩 [Landing Page (Website)](https://sites.google.com/view/deepthink/home)
- 🧩 [Weekly Meeting Record (Docs)](https://anu365-my.sharepoint.com/:w:/g/personal/u7779491_anu_edu_au/ETsG5hYUFolOm8YgzA7JOjQBOcjZiMiZDUAs_TsFEfNG7A?e=UahHmo)
- 🧩 [Reflection log (Docs)](https://docs.google.com/document/d/1sdAgFRltdWNN607z7K-vBRSHbkXO1tB8jcmmhmoRJFk/edit?usp=sharing)
- 🧩 [Scrum log (Docs)](https://docs.google.com/document/d/1mTqhx3Qx7PSceR9ZKhv2mKJX5xxrKtjKlYn27QcoV8g/edit?usp=sharing)
- 🧩 [Risk log (Docs)](https://docs.google.com/document/d/1P9ITq3K_k2EMazB4LNoyt7epT0v5S0n7MWlrb-fu4-s/edit?usp=sharing)
- 🧩 [Issue (Github Page)](https://github.com/orgs/southern-cross-ai/projects/44/views/1)

---

## 👥 Team Members
| Name | Role | Email |
|------|------|-------|
| XiangyuTan | Team member | u7779491@anu.edu.au |
| Diming Xu | Team member | u7705332@anu.edu.au |
| Zhuiqi Lin | Team member | u7733924@anu.edu.au |
| Boyang Zhang | Team member | u7760642@anu.edu.au |
| Qingchuan Rui | Team member | u7776331@anu.edu.au |
| Dongze Yu | Team member | u7775416@anu.edu.au |
