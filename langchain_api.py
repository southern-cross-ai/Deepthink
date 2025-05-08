from fastapi import FastAPI, Request
from pydantic import BaseModel
from langchain_ollama import ChatOllama
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
import uvicorn
import logging

# ✅ 启用日志打印
logging.basicConfig(level=logging.INFO)

# ✅ 初始化 FastAPI 实例
app = FastAPI()

# ✅ 定义请求格式
class ChatRequest(BaseModel):
    topic: str

# ✅ 初始化 LangChain 元件
prompt = PromptTemplate.from_template("{topic}")
model = ChatOllama(model="llama2", base_url="http://localhost:11434", streaming=False)
parser = StrOutputParser()

@app.post("/chat")
async def chat(req: ChatRequest):
    logging.info(f"💬 接收到用户输入: {req.topic}")
    formatted = prompt.format(topic=req.topic)
    logging.info(f"📨 Prompt 模板后: {formatted}")
    llm_result = model.invoke(formatted)
    logging.info(f"🤖 LLM 返回：{llm_result}")
    parsed = parser.invoke(llm_result)
    return {"response": parsed}

# ✅ 允许直接运行：uvicorn langchain_api:app --host 0.0.0.0 --port 8000
if __name__ == "__main__":
    uvicorn.run("langchain_api:app", host="0.0.0.0", port=8000, reload=False)