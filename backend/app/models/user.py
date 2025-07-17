# flake8: noqa: E501
from app.db.init_db import Base
from sqlalchemy import Column, DateTime, Integer, String, func


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    username = Column(
        String(64), unique=True, nullable=False, index=True, comment="用户名"
    )
    email = Column(String(128), unique=True, nullable=False, index=True, comment="邮箱")
    hashed_password = Column(String(128), nullable=False, comment="加密密码")
    full_name = Column(String(128), comment="姓名")
    is_active = Column(Integer, default=1, comment="是否激活")
    created_at = Column(DateTime, server_default=func.now(), comment="创建时间")
    updated_at = Column(
        DateTime, server_default=func.now(), onupdate=func.now(), comment="更新时间"
    )
