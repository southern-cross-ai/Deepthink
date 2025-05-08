import gradio as gr
import requests

def chat_with_ollama(prompt, history):
    if not isinstance(history, list):
        history = []
    # messages = [] # messages is a list to store fomer messages
    # for user_msg, bot_msg in history:
    #     messages.append({"role": "user", "content": user_msg})
    #     messages.append({"role": "assistant", "content": bot_msg})
    # messages.append({"role": "user", "content": prompt})
    try:
        # 调用 LangChain API（封装了 prompt/llm/parser）
        response = requests.post(
            "http://localhost:8000/chat",
            json={"topic": prompt}
        )

        reply = response.json().get("response", "[Error: no response]")
    except Exception as e:
        reply = f"[Error calling LangChain API: {e}]"

    history.append((prompt, reply))
    return history, history

iface = gr.Interface(
    fn=chat_with_ollama,
    inputs=[gr.Textbox(label="Your message"), gr.State([])],
    outputs=[gr.Chatbot(), gr.State([])],
    title="Ollama + Gradio in One Container"
)

iface.launch(server_name="0.0.0.0", server_port=7860)