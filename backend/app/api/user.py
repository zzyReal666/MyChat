"""
用户接口路由（Controller）
- 负责接收HTTP请求、参数校验、调用Service层
- 类似Java的@RestController + @RequestMapping
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.models.user import UserCreate, User
from app.services.user_service import create_user
from app.db import init_db

router = APIRouter()


def get_db():
    db = init_db.SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/users/", response_model=UserCreate, status_code=status.HTTP_201_CREATED)
def api_create_user(user_in: UserCreate, db: Session = Depends(get_db)):
    """
    创建用户接口
    - 接收POST请求，参数自动校验
    - 调用Service层完成业务
    - 返回创建成功的用户信息
    """
    # 检查用户名或邮箱是否已存在（可选，实际开发建议加上）
    # 这里只做最基础的创建
    try:
        user = create_user(db, user_in)
        return user
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
