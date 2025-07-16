"""
全局配置文件，支持多环境变量加载。
"""
import os
from dotenv import load_dotenv

# 加载.env文件（如有）
load_dotenv()

class Settings:
    # 数据库配置
    POSTGRES_URI: str = os.getenv("POSTGRES_URI", "postgresql://user:password@localhost:5432/mychat")
    MONGO_URI: str = os.getenv("MONGO_URI", "mongodb://localhost:27017")
    MILVUS_HOST: str = os.getenv("MILVUS_HOST", "localhost")
    MILVUS_PORT: int = int(os.getenv("MILVUS_PORT", 19530))
    # 其他配置
    DEBUG: bool = os.getenv("DEBUG", "false").lower() == "true"
    SECRET_KEY: str = os.getenv("SECRET_KEY", "changeme")

settings = Settings() 