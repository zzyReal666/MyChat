# Vue 3 + Vite

This template should help get you started developing with Vue 3 in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

Learn more about IDE Support for Vue in the [Vue Docs Scaling up Guide](https://vuejs.org/guide/scaling-up/tooling.html#ide-support).

## 本地开发启动命令

```bash
# 进入前端目录
cd frontend

# （建议先升级Node到20+，见下方说明）

# 安装依赖
npm install

# 启动开发服务器
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
