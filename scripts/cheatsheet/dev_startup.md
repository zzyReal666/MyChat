# MyChat 前后端本地开发启动命令速查

## 1. 启动后端（FastAPI）

```bash
# 进入项目根目录，激活虚拟环境
cd /Users/zhangzhongyuan/PycharmProjects/MyChat
source .mychatvenv/bin/activate

# 启动后端服务
uvicorn app.core.main:app --reload --app-dir backend
```

## 2. 启动前端（Vue3 + Vite）

```bash
# 进入前端目录
cd /Users/zhangzhongyuan/PycharmProjects/MyChat/frontend

# （建议先升级Node到20+，见README说明）

# 安装依赖（首次或依赖变更时）
npm install

# 启动前端开发服务器
npm run dev
```

---
> 如遇端口冲突、依赖报错、Node版本不符等问题，请优先检查README和终端报错信息。 