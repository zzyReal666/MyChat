"""
FastAPI 主程序入口。
- 启动应用，加载路由、数据库、CORS等中间件。
- 适合企业级扩展。
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.db.init_db import init_postgres, create_tables, init_mongo, init_milvus
from app.api.chat import router as chat_router
from app.api.user import router as user_router
from sqlalchemy.orm import Session
from app.models.user import User, UserCreate
from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    init_postgres()
    create_tables()
    print("\n🚀 服务已启动！")
    print("Swagger文档: http://localhost:8000/docs")
    print("Redoc文档:   http://localhost:8000/redoc")
    print("API根路径:   http://localhost:8000/")
    yield
    # 可在这里添加关闭时的清理逻辑

# 创建 FastAPI 实例
app = FastAPI(title="MyChat 企业级RAG平台", version="1.0.0", lifespan=lifespan)

# 配置 CORS，允许前端跨域访问
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境建议指定域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 加载API路由
app.include_router(chat_router, prefix="/api")
app.include_router(user_router, prefix="/api")

def create_user(db: Session, user_in: UserCreate) -> User:
    # 先查找是否已存在相同邮箱或用户名
    exist = db.query(User).filter(
        (User.username == user_in.username) | (User.email == user_in.email)
    ).first()
    if exist:
        # 可以抛出HTTP异常，返回友好提示
        raise ValueError("用户名或邮箱已存在")
    user = User(username=user_in.username, email=user_in.email)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user 