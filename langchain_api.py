from fastapi import FastAPI
from pydantic import BaseModel
from langchain_ollama import ChatOllama
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
import uvicorn
import logging
import sys

# Enable logging
logging.basicConfig(level=logging.INFO, stream=sys.stdout)

# Initialize FastAPI app
app = FastAPI()

# Request schema with optional model name
class ChatRequest(BaseModel):
    topic: str
    model: str = "llama3.2"  # default model

# Constant components (prompt + parser)
prompt = PromptTemplate.from_template("{topic}")
parser = StrOutputParser()

@app.post("/chat")
async def chat(req: ChatRequest):
    logging.info(f"💬 Received prompt: {req.topic}")
    logging.info(f"📦 Using model: {req.model}")

    # Dynamically instantiate LLM
    try:
        model = ChatOllama(model=req.model, base_url="http://localhost:11434", streaming=False)
    except Exception as e:
        logging.error(f"❌ Failed to load model: {e}")
        return {"response": f"[Error: Failed to load model '{req.model}']"}

    # Format + invoke model
    formatted = prompt.format(topic=req.topic)
    logging.info(f"📨 Prompt after formatting: {formatted}")

    try:
        llm_result = model.invoke(formatted)
        parsed = parser.invoke(llm_result)
    except Exception as e:
        return {"response": f"[Error calling model: {e}]"}
    
    logging.info(f"🤖 Model reply: {parsed}")
    return {"response": parsed}

# Start server if run directly
if __name__ == "__main__":
    uvicorn.run("langchain_api:app", host="0.0.0.0", port=8000, reload=False)