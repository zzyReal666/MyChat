# MyChat CI/CD 工作流说明

## 概述
本项目实现了完整的企业级CI/CD流水线，包含代码质量检查、安全扫描、测试、构建和部署等环节。

## 工作流文件

### 1ci-cd.yml - 主CI/CD流水线
**触发条件：**
- 推送到 `main` 或 `develop` 分支
- 创建Pull Request到 `main` 或 `develop` 分支
- 手动触发

**包含的作业：**

#### 代码质量检查 (code-quality)
- Python代码格式化检查 (black, isort)
- Python代码风格检查 (flake8
- Python类型检查 (mypy)
- ESLint检查 (前端)
- 代码覆盖率检查

#### 安全扫描 (security-scan)
- Python安全扫描 (bandit, safety)
- Node.js安全扫描 (npm audit)
- 生成安全报告

#### 后端测试 (test-backend)
- 单元测试和集成测试
- 数据库测试 (PostgreSQL)
- 覆盖率报告生成

#### 前端测试 (test-frontend)
- 前端构建测试
- 构建产物上传

#### 构建Docker镜像 (build-images)
- 构建后端Docker镜像
- 构建前端Docker镜像
- 推送到GitHub Container Registry

#### 部署到测试环境 (deploy-staging)
- 仅在 `develop` 分支触发
- 部署到Kubernetes测试环境

#### 部署到生产环境 (deploy-production)
- 仅在 `main` 分支触发
- 部署到Kubernetes生产环境
- 健康检查

#### 通知 (notify)
- Slack通知
- 邮件通知

### 2. release.yml - 发布工作流
**触发条件：**
- 推送版本标签 (v*)

**功能：**
- 运行完整测试套件
- 构建Docker镜像
- 创建GitHub Release
- 生成发布说明

## 配置文件

### 后端配置
- `backend/pytest.ini` - pytest测试配置
- `backend/.flake8` - flake8码风格配置
- `backend/pyproject.toml` - 代码格式化和类型检查配置

### 前端配置
- `frontend/.eslintrc.json` - ESLint代码质量配置

### 依赖管理
- `.github/dependabot.yml` - 自动依赖更新配置

## 环境变量和密钥

### 必需的GitHub Secrets
```yaml
# Kubernetes配置
KUBE_CONFIG_STAGING: base64编码的测试环境kubeconfig
KUBE_CONFIG_PROD: base64码的生产环境kubeconfig

# 通知配置
SLACK_WEBHOOK: Slack Webhook URL
```

### 环境变量
```yaml
# 容器注册表
REGISTRY: ghcr.io
IMAGE_NAME: ${{ github.repository }}
```

## 使用说明

### 1 本地开发
```bash
# 后端
cd backend
pip install -r requirements.txt
pytest  # 运行测试
black .  # 格式化代码
flake8 .  # 检查代码风格

# 前端
cd frontend
npm install
npm run build  # 构建测试
```

### 2. 提交代码
```bash
git add .
git commit -mfeat: 添加新功能"
git push origin feature/new-feature
```

### 3. 创建Pull Request
- 从feature分支创建PR到develop分支
- CI/CD会自动运行所有检查
- 通过所有检查后可以合并

### 4. 发布版本
```bash
git tag v1.00
git push origin v10
```

## 最佳实践

### 1. 代码质量
- 提交前运行本地测试
- 确保代码覆盖率不低于70%
- 遵循代码风格指南

### 2 分支策略
- `main`: 生产环境代码
- `develop`: 开发环境代码
- `feature/*`: 功能开发分支
- `hotfix/*`: 紧急修复分支

### 3. 提交信息
使用约定式提交：
- `feat:` 新功能
- `fix:` 修复bug
- `docs:` 文档更新
- `style:` 代码格式
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

### 4. 安全
- 定期更新依赖
- 关注安全扫描报告
- 及时修复安全漏洞

## 故障排除

### 常见问题1. **测试失败**: 检查测试代码和依赖
2. **构建失败**: 检查Dockerfile和依赖
3. **部署失败**: 检查Kubernetes配置和权限
4 **安全扫描失败**: 更新有安全漏洞的依赖

### 日志查看
- GitHub Actions页面查看详细日志
- 下载构建产物和报告
- 查看部署状态

## 扩展建议

### 1. 告警
- 集成Prometheus监控
- 设置告警规则
- 添加性能监控

### 2. 回滚机制
- 自动回滚失败的部署
- 版本回滚脚本
- 数据库迁移回滚

### 3. 多环境支持
- 开发环境
- 测试环境
- 预生产环境
- 生产环境

### 4. 性能优化
- 并行执行作业
- 缓存优化
- 构建时间优化 
