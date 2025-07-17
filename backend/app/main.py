from fastapi import FastAPI
from app.api import chat

app = FastAPI(
    title="MyChat RAG API",
    description="基于Langchain+FAISS+阿里百炼的RAG问答服务",
    version="0.1.0",
)

# 挂载chat路由
app.include_router(chat.router, prefix="/api")
