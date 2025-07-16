# MyChat

## 项目简介
本项目基于 FastAPI + Langchain，支持 ChatGLM、Qwen、Llama 等大模型的 RAG 与 Agent 应用，采用前后端分离架构。

## 目录结构

```text
MyChat/
├── backend/           # 后端 FastAPI 服务，集成 Langchain、模型适配、RAG/Agent 逻辑
│   ├── app/           # FastAPI 应用主目录
│   │   ├── api/       # 路由与接口
│   │   ├── core/      # 配置、启动、依赖注入
│   │   ├── models/    # 数据模型（Pydantic/ORM）
│   │   ├── services/  # 业务逻辑、RAG/Agent 实现
│   │   ├── llms/      # 各类大模型适配（ChatGLM/Qwen/Llama等）
│   │   └── utils/     # 工具函数
│   └── tests/         # 后端测试
├── frontend/          # 前端项目（如 React/Vue）
│   └── ...            # 前端相关目录
├── scripts/           # 启动、部署、数据处理等脚本
├── doc/               # 项目文档
└── README.MD          # 项目说明
```

## 快速开始
（后续补充安装、运行、开发说明）

## 本地开发启动命令

### 后端（FastAPI）
```bash
# 进入项目根目录，激活虚拟环境 根据自己环境修改名称
cd /Users/zhangzhongyuan/PycharmProjects/MyChat
source .venv/bin/activate

# 启动后端服务
uvicorn app.core.main:app --reload --app-dir backend
```

### 前端（Vue3 + Vite）
```bash
# 进入前端目录
cd frontend

# （建议先升级Node到20+，见下方说明）

# 安装依赖（首次或依赖变更时）
npm install

# 启动前端开发服务器
npm run dev
```

### Node版本要求
- 推荐Node.js 20及以上，否则Vite等依赖可能报错。
- 升级建议：使用nvm（Node Version Manager）管理Node版本。

```bash
# 安装nvm（如未安装）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh

# 安装并切换到Node.js 20
nvm install 20
nvm use 20
node -v  # 确认输出v20.x.x
```

