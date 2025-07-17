"""
用户数据模型定义
- UserCreate: 用于接口请求体校验（类似Java的DTO）
- User: ORM模型，映射到Postgres数据库（类似Java的JPA实体类）
"""

from pydantic import (
    BaseModel,
    EmailStr,
)  # Pydantic用于数据校验，类似Java的Bean Validation
from sqlalchemy import (
    Column,
    Integer,
    String,
)  # SQLAlchemy用于ORM映射，类似Java的JPA注解
from sqlalchemy.ext.declarative import declarative_base

# SQLAlchemy ORM基类，类似Java的 @Entity 基类
Base = declarative_base()


class User(Base):
    """
    ORM模型：用户表结构
    类似Java的@Entity @Table(name="users")
    """

    __tablename__ = "users"  # 指定表名
    id = Column(Integer, primary_key=True, index=True)  # 主键，自增
    username = Column(
        String(32), unique=True, index=True, nullable=False
    )  # 用户名，唯一且不可为空
    email = Column(
        String(128), unique=True, index=True, nullable=False
    )  # 邮箱，唯一且不可为空


class UserCreate(BaseModel):
    """
    Pydantic模型：用于创建用户的请求体校验
    类似Java的DTO/VO，自动校验类型和格式
    """

    username: str  # 用户名，字符串类型
    email: EmailStr  # 邮箱，自动校验格式
