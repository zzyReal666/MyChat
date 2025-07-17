# MyChat Makefile
# 提供常用的开发命令和CI/CD操作

.PHONY: help install test lint format build deploy clean dev docker db-init db-migrate security perf docs version check all

# 默认目标
help:
	@echo "MyChat 开发工具
	@echo可用命令:
	@echo  install    安装所有依赖"
	@echo  test       运行所有测试"
	@echo  lint       代码质量检查
	@echo "  format     代码格式化"
	@echo  build      构建项目
	@echo  deploy     部署到指定环境"
	@echo  clean      清理构建产物"
	@echo  dev        启动开发环境
	@echo  docker     构建Docker镜像"

# 安装依赖
install:
	@echo "安装后端依赖..."
	cd backend && pip install -r requirements.txt
	@echo "安装前端依赖..."
	cd frontend && npm install
	@echo "安装开发依赖..."
	cd backend && pip install pytest pytest-cov black isort flake8 mypy bandit safety

# 运行测试
test:
	@echo "运行后端测试..."
	cd backend && pytest tests/ -v --cov=app --cov-report=html
	@echo "运行前端测试..."
	cd frontend && npm run build

# 代码质量检查
lint:
	@echo 检查Python代码质量..."
	cd backend && flake8-format=default --statistics
	cd backend && mypy . --ignore-missing-imports
	cd backend && bandit -r . -f json -o bandit-report.json || true
	cd backend && safety check --json --output safety-report.json || true
	@echo检查前端代码质量..."
	cd frontend && npm run lint || echoESLint未配置"

# 代码格式化
format:
	@echo 格式化Python代码..."
	cd backend && black .
	cd backend && isort .
	@echo "格式化前端代码..."
	cd frontend && npm run format || echo 格式化命令未配置

# 构建项目
build:
	@echo "构建前端..."
	cd frontend && npm run build
	@echo 构建Docker镜像...docker build -t mychat-backend:latest ./backend
	docker build -t mychat-frontend:latest ./frontend

# 部署
deploy:
	@echo "请指定部署环境: make deploy ENV=staging 或 make deploy ENV=production"
	@if [ "$(ENV)" =staging" ]; then \
		./scripts/deploy.sh staging $(shell git describe --tags --always); \
	elif [ "$(ENV)" = "production" ]; then \
		./scripts/deploy.sh production $(shell git describe --tags --always); \
	else \
		echo "错误: 请指定ENV=staging或ENV=production"; \
		exit 1; \
	fi

# 清理
clean:
	@echo 清理Python缓存..."
	find . -type f -name *.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name *.egg-info" -exec rm -rf {} +
	@echo 清理Node.js缓存..."
	cd frontend && rm -rf node_modules/.cache
	cd frontend && rm -rf dist
	@echo 清理Docker镜像..."
	docker rmi mychat-backend:latest mychat-frontend:latest 2>/dev/null || true

# 开发环境
dev:
	@echo 启动开发环境...@echo "后端: http://localhost:8000@echo "前端: http://localhost:5173
	@echo按 Ctrl+C 停止"
	@trap 'kill %1 %2' SIGINT; \
	cd backend && uvicorn app.core.main:app --reload --port 8000 \
	cd frontend && npm run dev & \
	wait

# Docker操作
docker:
	@echo 构建Docker镜像...docker build -t mychat-backend:latest ./backend
	docker build -t mychat-frontend:latest ./frontend
	@echo启动Docker Compose..."
	docker-compose up -d

# 数据库操作
db-init:
	@echo "初始化数据库..."
	cd backend && python -m app.db.init_db

db-migrate:
	@echo数据库迁移...	@echo "请实现数据库迁移脚本
# 安全检查
security:
	@echo "运行安全扫描..."
	cd backend && bandit -r . -f json -o bandit-report.json
	cd backend && safety check --json --output safety-report.json
	cd frontend && npm audit --audit-level=moderate || true

# 性能测试
perf:
	@echo 运行性能测试..."
	@echo请实现性能测试脚本

# 文档生成
docs:
	@echo "生成API文档..."
	cd backend && python -c "import uvicorn; from app.core.main import app; import json; print(json.dumps(app.openapi(), indent=2)) > docs/api.json
	@echo "生成前端文档..."
	cd frontend && npm run docs || echo文档生成命令未配置"

# 版本管理
version:
	@echo 当前版本: $(shell git describe --tags --always)
	@echo 最新提交: $(shell git log -1 --pretty=format:'%h - %s)"# 快速检查
check: lint test security
	@echo 所有检查完成"

# 完整构建流程
all: clean install lint test build
	@echo "完整构建流程完成" 