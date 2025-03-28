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
        json={
            "model": "llama2",
            "messages": messages,
            "stream": False
        }
    )

    reply = response.json()["message"]["content"]
    history.append((prompt, reply))
    return history, history

iface = gr.Interface(
    fn=chat_with_ollama,
    inputs=[gr.Textbox(label="Your message"), gr.State([])],
    outputs=[gr.Chatbot(), gr.State([])],
    title="Ollama + Gradio in One Container"
)

iface.launch(server_name="0.0.0.0", server_port=7860)