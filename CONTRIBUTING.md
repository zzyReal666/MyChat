# 贡献指南 (Contributing Guide)

## 🚀 Git开发流程

### 分支策略

我们使用 **Git Flow** 工作流：

- `main` - 生产环境分支，只接受经过测试的稳定代码
- `develop` - 开发环境分支，集成所有功能开发
- `feature/*` - 功能分支，用于开发新功能
- `hotfix/*` - 热修复分支，用于紧急修复生产问题
- `release/*` - 发布分支，用于准备新版本发布

### 标准开发流程

#### 1. 开始新功能开发

```bash
# 确保在develop分支上
git checkout develop
git pull origin develop

# 创建功能分支
git checkout -b feature/your-feature-name

# 开始开发...
```

#### 2. 开发过程中的提交

```bash
# 添加更改
git add .

# 提交更改（使用规范的提交信息）
git commit -m "feat: 添加用户登录功能"
git commit -m "fix: 修复登录验证bug"
git commit -m "docs: 更新API文档"
git commit -m "style: 格式化代码"
git commit -m "refactor: 重构用户服务"
git commit -m "test: 添加用户登录测试"
```

#### 3. 推送功能分支

```bash
# 推送到远程仓库
git push origin feature/your-feature-name
```

#### 4. 创建Pull Request

- 在GitHub上创建PR，从 `feature/your-feature-name` 到 `develop`
- 填写PR描述，说明功能变更
- 等待代码审查
- 通过CI/CD检查

#### 5. 合并和清理

- 审查通过后合并到develop分支
- 删除功能分支
- 定期将develop合并到main进行发布

### 分支同步策略

#### 为什么需要同步？

- **保持代码一致性**：确保develop和main分支的代码状态一致
- **避免冲突**：减少合并时的冲突
- **版本管理**：便于版本发布和回滚
- **团队协作**：确保所有开发者使用相同的代码基础

#### 同步时机和方向

```
发布新版本时：
develop → main (通过release分支或直接合并)

热修复后：
main → develop (将修复同步回开发分支)

定期检查：
监控分支差异，及时同步
```

#### 使用同步脚本

我们提供了自动化脚本来管理分支同步：

```bash
# 检查分支状态
./scripts/sync-branches.sh status

# 发布新版本（develop → main）
./scripts/sync-branches.sh release

# 热修复后同步（main → develop）
./scripts/sync-branches.sh sync-main

# 定期同步检查
./scripts/sync-branches.sh periodic

# 创建发布标签
./scripts/sync-branches.sh tag v1.0.0
```

#### 同步最佳实践

1. **定期同步**：
   - 每周至少检查一次分支状态
   - 当develop领先main超过50个提交时，考虑发布新版本

2. **发布流程**：
   ```bash
   # 1. 检查develop分支状态
   ./scripts/sync-branches.sh status
   
   # 2. 发布新版本
   ./scripts/sync-branches.sh release
   
   # 3. 创建版本标签
   ./scripts/sync-branches.sh tag v1.0.0
   ```

3. **热修复流程**：
   ```bash
   # 1. 从main创建热修复分支
   ./scripts/dev-workflow.sh start-hotfix critical-fix
   
   # 2. 修复问题并提交
   ./scripts/dev-workflow.sh commit fix "修复关键问题"
   
   # 3. 完成热修复
   ./scripts/dev-workflow.sh finish-hotfix
   
   # 4. 创建PR到main分支
   # 5. 合并后同步到develop
   ./scripts/sync-branches.sh sync-main
   ```

4. **自动化检查**：
   - 可以设置GitHub Actions定期运行同步检查
   - 当检测到分支差异过大时自动通知

#### 分支保护规则

建议在GitHub上设置以下分支保护规则：

**Main分支保护**：
- 要求Pull Request审查
- 要求状态检查通过
- 禁止直接推送
- 要求线性历史

**Develop分支保护**：
- 要求Pull Request审查
- 要求状态检查通过
- 允许管理员直接推送

### 提交信息规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

- `feat:` - 新功能
- `fix:` - 修复bug
- `docs:` - 文档更新
- `style:` - 代码格式调整
- `refactor:` - 代码重构
- `test:` - 测试相关
- `chore:` - 构建过程或辅助工具的变动

### 紧急修复流程

```bash
# 从main分支创建热修复分支
git checkout main
git checkout -b hotfix/critical-bug-fix

# 修复问题
git add .
git commit -m "fix: 修复关键安全漏洞"

# 推送到远程
git push origin hotfix/critical-bug-fix

# 创建PR到main和develop
```

### 重要提醒

⚠️ **永远不要直接在main分支上开发！**

- main分支应该始终保持稳定
- 所有开发工作都在功能分支上进行
- 通过Pull Request进行代码审查
- 确保CI/CD检查通过后再合并

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