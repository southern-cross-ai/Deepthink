import gradio as gr
import requests
import subprocess

def get_available_ollama_models():
    try:
        result = subprocess.run(["ollama", "list"], capture_output=True, text=True, check=True)
        lines = result.stdout.strip().split("\n")[1:]  # Skip header
        models = [line.split()[0] for line in lines if line.strip()]
        return models
    except Exception as e:
        print(f"[ERROR] Failed to get model list: {e}")
        return ["llama2"]

def chat_with_ollama(prompt, history, model="llama2"):
    if not isinstance(history, list):
        history = []
    try:
        response = requests.post(
            "http://localhost:8000/chat",
            json={"topic": prompt, "model": model},
        )
        reply = response.json().get("response", "[Error: no response]")
    except Exception as e:
        reply = f"[Error calling LangChain API: {e}]"

    history.append((prompt, reply))
    return history, history

available_models = get_available_ollama_models()

with gr.Blocks(title="Deepthink LLM Chatbot", theme=gr.themes.Soft()) as demo:
    gr.Markdown("# 🤖 Deepthink LLM Chatbot\nChat naturally with powerful models.", elem_id="title")

    with gr.Row():
        chatbot = gr.Chatbot(height=450, show_copy_button=True, bubble_full_width=False, show_label=False)
        with gr.Column(scale=0.3):
            gr.Markdown("### ⚙️ Settings")
            model_dropdown = gr.Dropdown(
                choices=available_models,
                value="llama2",
                label="Model Selection"
            )
            clear_btn = gr.Button("🧹 Clear Chat")

    state = gr.State([])

    with gr.Row():
        user_input = gr.Textbox(
            show_label=False,
            placeholder="💬 Type your message and hit Enter...",
            lines=1
        )
        send_btn = gr.Button("🚀 Send", variant="primary")

    # Event bindings
    send_btn.click(
        fn=chat_with_ollama,
        inputs=[user_input, state, model_dropdown],
        outputs=[chatbot, state]
    )

    user_input.submit(
        fn=chat_with_ollama,
        inputs=[user_input, state, model_dropdown],
        outputs=[chatbot, state]
    )

    clear_btn.click(
        lambda: ([], []),
        inputs=None,
        outputs=[chatbot, state]
    )

demo.launch(server_name="0.0.0.0", server_port=7860)
