"""
数据库初始化模块。
- 提供Postgres、MongoDB、Milvus的连接初始化方法。
"""

from app.core.config import settings
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()

engine = None
SessionLocal = None


def init_postgres():
    """
    初始化Postgres数据库连接
    """
    global engine, SessionLocal
    engine = create_engine(settings.POSTGRES_URI, pool_pre_ping=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    print(f"[DB] Postgres已连接: {settings.POSTGRES_URI}")


def create_tables():
    """
    创建所有ORM模型对应的数据库表（类似Java的Hibernate自动建表）
    """
    if engine is not None:
        Base.metadata.create_all(bind=engine)
        print("[DB] 数据库表已创建")
    else:
        print("[DB] 请先初始化Postgres连接")
