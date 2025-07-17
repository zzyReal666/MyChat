"""
数据库初始化模块。
- 提供Postgres、MongoDB、Milvus的连接初始化方法。
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from pymongo import MongoClient
from pymilvus import connections

# Postgres连接
engine = None
SessionLocal = None


def init_postgres():
    """初始化Postgres数据库连接"""
    global engine, SessionLocal
    engine = create_engine(settings.POSTGRES_URI, pool_pre_ping=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    print("[DB] Postgres已连接")


# MongoDB连接
mongo_client = None


def init_mongo():
    """初始化MongoDB连接"""
    global mongo_client
    mongo_client = MongoClient(settings.MONGO_URI)
    print("[DB] MongoDB已连接")


# Milvus连接


def init_milvus():
    """初始化Milvus连接"""
    connections.connect(host=settings.MILVUS_HOST, port=settings.MILVUS_PORT)
    print("[DB] Milvus已连接")


def create_tables():
    """
    创建所有ORM模型对应的数据库表（类似Java的Hibernate自动建表）
    """
    if engine is not None:
        Base.metadata.create_all(bind=engine)
        print("[DB] 数据库表已创建")
    else:
        print("[DB] 请先初始化Postgres连接")
