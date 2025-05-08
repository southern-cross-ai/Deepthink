import gradio as gr
import requests
import subprocess

# Supported models
def get_available_ollama_models():
    try:
        result = subprocess.run(["ollama", "list"], capture_output=True, text=True, check=True)
        lines = result.stdout.strip().split("\n")[1:]  # Skip the header
        models = [line.split()[0] for line in lines if line.strip()]
        return models
    except Exception as e:
        print(f"[ERROR] Failed to get model list: {e}")
        return ["llama3.2"]  # fallback to default


def chat_with_ollama(prompt, history, model="llama3.2"):
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

        reply = response.json().get("response", "[Error: no response]")
    except Exception as e:
        reply = f"[Error calling LangChain API: {e}]"

    history.append((prompt, reply))
    return history, history

available_models = get_available_ollama_models()

with gr.Blocks(title="Ollama Chat (Multi-model)") as demo:
    gr.Markdown("Deepthink LLM Chatbot")
    
    model_dropdown = gr.Dropdown(choices=available_models, value="llama3.2", label="Choose a model")
    chatbot = gr.Chatbot()
    state = gr.State([])

    with gr.Row():
        user_input = gr.Textbox(label="Your Message", placeholder="Ask me anything...")
        send_btn = gr.Button("Send")

    send_btn.click(
        fn=chat_with_ollama,
        inputs=[user_input, state, model_dropdown],
        outputs=[chatbot, state]
    )

demo.launch(server_name="0.0.0.0", server_port=7860)