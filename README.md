# MyChat（学习项目）

> 本项目为个人学习与实践用途，聚焦于 RAG（检索增强生成）与 Agent 技术的探索与实现。

## 项目简介
本项目基于 FastAPI + Langchain，支持 ChatGLM、Qwen、Llama 等大模型的 RAG 与 Agent 应用，采用前后端分离架构。所有功能均以学习和技术积累为目标，代码结构和实现持续优化中。

## 界面预览

![MyChat 前端界面预览](docs/screenshot-main.png)

> 示例：RAG 智能对话主界面，左侧为会话与工具栏，右侧为作者信息区，中间为智能对话窗口。

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
│   │   ├── db/        # 数据库初始化与连接
│   │   ├── utils/     # 工具函数
│   │   └── tasks/     # 异步任务、定时任务
│   └── tests/         # 后端测试
├── frontend/          # 前端项目（Vue3 + Vite）
├── scripts/           # 启动、部署、数据处理等脚本
├── doc/               # 项目文档与学习记录
└── README.md          # 项目说明
```

## 功能列表

### 已实现功能
- [x] FastAPI 后端服务搭建与基础配置
- [x] 用户注册接口（含唯一性校验）
- [x] 基于 Langchain 的 RAG 问答服务
- [x] 支持多种大模型适配（ChatGLM、Qwen、Llama，适配器结构）
- [x] 本地 FAISS 向量库集成
- [x] 前后端分离架构，Vue3 + Vite 前端基础页面
- [x] 数据库（Postgres）初始化与自动建表
- [x] API 文档自动生成（Swagger/Redoc，支持中文注释）
- [x] 跨域（CORS）支持

### 计划实现功能
- [ ] Agent 智能体能力扩展（如多步推理、工具调用）
- [ ] 用户登录与鉴权（JWT/OAuth2）
- [ ] 多数据源知识库接入（如 PDF/网页/数据库等）
- [ ] 向量数据库 Milvus/MongoDB 集成
- [ ] 前端对话与知识库管理页面
- [ ] 任务调度与异步处理（Celery/定时任务）
- [ ] 更丰富的模型推理与微调接口
- [ ] 部署与运维脚本完善（Docker/K8s）

## 声明
本项目为**个人学习项目**，所有代码仅供学习与交流，欢迎提出建议与交流心得。

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

