"""
用户接口测试用例
- 使用pytest进行接口测试，类似Java的SpringBootTest + MockMvc
"""
import pytest
from fastapi.testclient import TestClient
from app.core.main import app

# 创建FastAPI测试客户端，类似Java的MockMvc
client = TestClient(app)

def test_create_user():
    """
    测试创建用户接口
    - 发送POST请求，断言返回结果
    """
    payload = {
        "username": "testuser",
        "email": "testuser@example.com"
    }
    response = client.post("/api/user/users/", json=payload)
    assert response.status_code == 201  # 断言HTTP状态码
    data = response.json()
    assert data["username"] == payload["username"]  # 断言用户名一致
    assert data["email"] == payload["email"]        # 断言邮箱一致 