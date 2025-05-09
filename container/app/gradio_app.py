import gradio as gr
import requests
import subprocess

# Supported models
def get_available_ollama_models():
    try:
        result = subprocess.run(["ollama", "list"], capture_output=True, text=True, check=True)
        lines = result.stdout.strip().split("\n")[1:]  # Skip the header
        models = list(set([line.split()[0].split(":")[0] for line in lines if line.strip()]))
        return models
    except Exception as e:
        print(f"[ERROR] Failed to get model list: {e}")
        return ["llama3.2"]  # fallback to default


def chat_with_ollama(prompt, history, model="llama3.2:3b"):
    """
    Function to handle chat with the Ollama model.
    Args:
        prompt (str): User's input message.
        history (list): Conversation history.
        model (str): Model name to use.
    Returns:
        tuple: Updated conversation history and the model's reply.
    """
    if not isinstance(history, list):
        history = []
    try:
        # Call LangChain API (wraps prompt/llm/parser)
        response = requests.post(
            "http://localhost:8000/chat",
            json={"topic": prompt,
                  "model": model},
        )
        response.raise_for_status()
        reply = response.json().get("response", "[Error: no response]")
    except Exception as e:
        print(f"[ERROR] {reply}")

    messages = history + [
        {"role": "user", "content": prompt},
        {"role": "assistant", "content": reply}
    ]

    return messages, messages

# UI
available_models = get_available_ollama_models()

with gr.Blocks(title="🧠 Ollama Multi-Model Chat", theme="soft") as demo:
    gr.Markdown("## 🤖 Deepthink Chatbot (Multi-Model)\nChoose a model and start chatting!")

    model_dropdown = gr.Dropdown(choices=available_models, value="llama3.2:3b", label="Model")

    chatbot = gr.Chatbot(type="messages")
    state = gr.State([])

    with gr.Row():
        txt = gr.Textbox(
            show_label=False,
            placeholder="Type your message and press Enter...",
            lines=1
        )

    txt.submit(
    fn=chat_with_ollama,
    inputs=[txt, state, model_dropdown],  # ✅ pass dropdown as input
    outputs=[chatbot, state]
    ).then(
        lambda: "", None, txt  # Clear textbox
    )

demo.launch(server_name="0.0.0.0", server_port=7860)