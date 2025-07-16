"""
用户服务层（Service）
- 负责处理与用户相关的业务逻辑
- 包含唯一性校验，防止重复注册
"""
from sqlalchemy.orm import Session
from app.models.user import User, UserCreate

def create_user(db: Session, user_in: UserCreate) -> User:
    """
    创建新用户，包含用户名和邮箱唯一性校验
    :param db: 数据库Session
    :param user_in: 用户创建请求体
    :return: 新建的User对象
    :raises ValueError: 用户名或邮箱已存在
    """
    # 检查用户名或邮箱是否已存在
    exist = db.query(User).filter(
        (User.username == user_in.username) | (User.email == user_in.email)
    ).first()
    if exist:
        raise ValueError("用户名或邮箱已存在")
    user = User(username=user_in.username, email=user_in.email)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user 