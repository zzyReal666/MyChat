# 贡献指南 (Contributing Guide)

欢迎为 MyChat 项目做出贡献！本文档将指导您如何参与项目开发。

## 📋 快速开始

### 1 Fork 项目
1. 访问MyChat GitHub 仓库](https://github.com/zzyReal666/MyChat)2. 点击右上角的Fork 按钮
3克隆您的 Fork 到本地：
```bash
git clone https://github.com/YOUR_USERNAME/MyChat.git
cd MyChat
```

### 2创建功能分支
```bash
git checkout -b feature/your-feature-name
# 或
git checkout -b fix/your-bug-fix
```

### 3. 开发与测试
```bash
# 安装依赖
make install

# 运行快速检查
./scripts/quick-check.sh

# 开发完成后运行完整检查
./scripts/pre-commit-check.sh
```

### 4. 提交代码
```bash
git add .
git commit -m "feat: 添加新功能描述"
git push origin feature/your-feature-name
```

### 5. 创建 Pull Request
1. 访问您的 GitHub Fork 页面
2. 点击 "Compare & pull request"3. 填写 PR 描述，使用提供的模板

---

## 🔍 代码提交前检查清单

### ✅ 必检项目（提交前必须通过）
- [ ] 代码格式化检查 (`black --check backend/`)
-  ] 代码风格检查 (`flake8-format=default --statistics backend/`)
-  导入排序检查 (`isort --check-only backend/`)
-  状态检查 (`git status`)
- [ ] 基础测试运行 (`pytest tests/`)

### ⚠️ 推荐检查项目
- 检查 (`mypy --ignore-missing-imports backend/`)
- ] 安全扫描 (`bandit -r backend/`)
- [ ] 前端代码检查 (`npm run lint`)
- [ ] 文档完整性检查

### 🔍 深度检查项目
- 性能测试
- [ ] 依赖安全检查 (`safety check`)
- ] 敏感信息检查

---

## 🚀 自动化检查

### 快速检查（日常开发）
```bash
./scripts/quick-check.sh
```

### 完整检查（重要提交）
```bash
./scripts/pre-commit-check.sh
```

### 使用 Makefile
```bash
# 安装依赖
make install

# 代码质量检查
make lint

# 运行测试
make test

# 代码格式化
make format

# 安全检查
make security
```

---

## 📝 代码规范

### Python 代码规范
- 使用 **Black** 进行代码格式化
- 使用 **Flake8** 进行代码风格检查
- 使用 **Isort** 进行导入排序
- 使用 **MyPy** 进行类型检查（推荐）

### 前端代码规范
- 使用 **ESLint** 进行代码检查
- 使用 **Prettier** 进行代码格式化（推荐）

### Git 提交规范
```bash
# 功能开发
git commit -m feat: 添加用户认证功能"

# 问题修复
git commit -m fix: 修复登录验证bug"

# 文档更新
git commit -m docs: 更新API文档"

# 代码重构
git commit -mrefactor: 重构用户服务模块"

# 测试相关
git commit -mtest: 添加用户认证测试用例
```

### 分支命名规范
```bash
# 功能分支
feature/user-auth
feature/chat-interface

# 修复分支
fix/login-bug
fix/api-error

# 文档分支
docs/api-update
docs/readme-improvement

# 发布分支
release/v1.0```

---

## 🧪 测试指南

### 后端测试
```bash
# 运行所有测试
cd backend && pytest tests/ -v

# 运行特定测试
pytest tests/test_chat.py -v

# 生成覆盖率报告
pytest tests/ --cov=app --cov-report=html
```

### 前端测试
```bash
# 运行测试
cd frontend && npm test

# 运行构建检查
npm run build
```

---

## 🔒 安全指南

### 代码安全
- 避免硬编码敏感信息（密码、密钥、Token）
- 使用环境变量管理配置
- 定期更新依赖包
- 运行安全扫描工具

### 依赖安全
```bash
# 检查 Python 依赖安全
safety check

# 检查 Node.js 依赖安全
npm audit
```

---

## 📚 文档规范

### 代码注释
- 使用清晰的函数和类文档字符串
- 为复杂逻辑添加行内注释
- 使用英文编写注释

### API 文档
- 使用 FastAPI 自动生成 API 文档
- 为每个端点添加详细描述
- 提供请求和响应示例

### 项目文档
- 保持 README.md 更新
- 编写详细的安装和使用指南
- 提供常见问题解答

---

## 🚨 常见问题

### 代码格式化问题
```bash
# 自动格式化 Python 代码
black backend/

# 自动排序导入
isort backend/
```

### 测试失败
```bash
# 检查测试环境
cd backend && python -c "import pytest; print('pytest 正常')"

# 运行单个测试文件
pytest tests/test_specific.py -v
```

### 构建失败
```bash
# 清理缓存
make clean

# 重新安装依赖
make install
```

---

## 🤝 代码审查

### PR 审查清单
-  ] 代码符合项目规范
- ] 所有测试通过
- ] 代码覆盖率达标
- ] 文档已更新
- ] 没有安全漏洞
- ] 性能影响可接受

### 审查者职责
- 检查代码质量和规范
- 验证功能实现正确性
- 确保测试覆盖充分
- 检查安全性和性能
- 提供建设性反馈

---

## 📞 获取帮助

如果您在贡献过程中遇到问题：

1. **查看文档**：阅读项目文档和本指南2. **搜索 Issues**：查看是否有类似问题
3. **创建 Issue**：描述您遇到的问题
4. **联系维护者**：通过 GitHub 或邮件联系

### 联系方式
- 项目维护者：张忠源 (Zhang Zhongyuan)
- 邮箱：zhangzhongyuan@example.com
- GitHub：[zzyReal666https://github.com/zzyReal666

---

## 📄 许可证

通过提交代码，您同意您的贡献将在 [MIT License](LICENSE) 下发布。

---

*感谢您为 MyChat 项目做出贡献！* 