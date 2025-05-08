# from langchain_community.chat_models import ChatOllama
from langchain_ollama import ChatOllama
'''
llm = ChatOllama(model="llama2", base_url="http://localhost:11434")
response = llm.invoke("你好，请介绍一下你是谁")
print(response.content)
'''

from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
# no reply, maybe the format imcompatibility
# 1.先尝试修改prompttemplate
#prompt = ChatPromptTemplate.from_template("请根据下面的主题写一篇小红书营销的短文： {topic}")
'''
from langchain_core.prompts import PromptTemplate
prompt = PromptTemplate.from_template("复述一遍主题： {topic}")
model = ChatOllama(model="llama2", base_url="http://localhost:11434")
output_parser = StrOutputParser()

chain = prompt | model | output_parser

chain.invoke({"topic": "康师傅绿茶"})
'''
# 2. 加入debug, 关闭流式输出，打印log----失败
from langchain_core.prompts import PromptTemplate
import logging
logging.basicConfig(level=logging.DEBUG)

# prompt = PromptTemplate.from_template("{topic}")
# model = ChatOllama(model="llama2", base_url="http://localhost:11434", streaming=False)
# output_parser = StrOutputParser()

# chain = prompt | model | output_parser

# chain.invoke({"topic": "hi"})
# 3. 分阶段测试
prompt = PromptTemplate.from_template("{topic}")
model = ChatOllama(model="llama2", base_url="http://localhost:11434", streaming=False)
output_parser = StrOutputParser()

formatted_prompt = prompt.format(topic="hi")
print("📨 Prompt 输出：", formatted_prompt)
#📨 Prompt 输出： hi

llm_response = model.invoke(formatted_prompt)
print("🤖 LLM 原始响应：", llm_response)
#🤖 LLM 原始响应： content="Hello! It's nice to meet you. Is there something I can help you with or would you like to chat?" 
# additional_kwargs={} 
# response_metadata={'model': 'llama2', 'created_at': '2025-04-11T06:17:38.567609324Z', 'done': True, 'done_reason': 'stop', 'total_duration': 209875198048, 'load_duration': 208896110967, 'prompt_eval_count': 21, 'prompt_eval_duration': 376542896, 'eval_count': 26, 'eval_duration': 600786082, 'message': Message(role='assistant', content='', images=None, tool_calls=None), 'model_name': 'llama2'} 
# id='run-75a5f4a2-f279-4e82-8f6f-0ba528083847-0' 
# usage_metadata={'input_tokens': 21, 'output_tokens': 26, 'total_tokens': 47}

parsed = output_parser.invoke(llm_response)
print("📦 最终解析结果：", parsed)
# 📦 最终解析结果： Hello! It's nice to meet you. Is there something I can help you with or would you like to chat?
