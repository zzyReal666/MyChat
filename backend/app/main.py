"""
FastAPI 主程序入口。
- 启动应用，加载路由、数据库、CORS等中间件。
- 适合企业级扩展。
"""

from contextlib import asynccontextmanager

from app.api.chat import router as chat_router
from app.db.init_db import create_tables, init_postgres
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_postgres()
    create_tables()
    print("🚀 服务已启动！")
    print("Swagger文档: http://localhost:8000/docs")
    print("Redoc文档:   http://localhost:8000/redoc")
    print("API根路径:   http://localhost:8000/")
    yield
    # 可在这里添加关闭时的清理逻辑


app = FastAPI(title="MyChat 企业级RAG平台", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境建议指定域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(chat_router, prefix="/api")
