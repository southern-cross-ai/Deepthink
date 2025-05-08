from fastapi import FastAPI
from pydantic import BaseModel
from langchain_ollama import ChatOllama
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
import uvicorn
import logging
import sys

# ✅ Enable logging output
logging.basicConfig(level=logging.INFO, stream=sys.stdout)

# ✅ Initialize FastAPI app
app = FastAPI()

# ✅ Define request schema
class ChatRequest(BaseModel):
    topic: str

# ✅ Initialize LangChain components
prompt = PromptTemplate.from_template("{topic}")
model = ChatOllama(model="llama2", base_url="http://localhost:11434", streaming=False)
parser = StrOutputParser()

@app.post("/chat")
async def chat(req: ChatRequest):
    logging.info(f"💬 Received user input: {req.topic}")
    formatted = prompt.format(topic=req.topic)
    logging.info(f"📨 After prompt formatting: {formatted}")
    llm_result = model.invoke(formatted)
    logging.info(f"🤖 LLM response: {llm_result}")
    parsed = parser.invoke(llm_result)
    return {"response": parsed}

# ✅ Allow script to be run directly with: uvicorn langchain_api:app --host 0.0.0.0 --port 8000
if __name__ == "__main__":
    uvicorn.run("langchain_api:app", host="0.0.0.0", port=8000, reload=False)