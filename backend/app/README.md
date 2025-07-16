# backend/app 目录说明

本目录为 FastAPI 主应用目录，包含后端所有核心代码。

- `api/`      ：接口路由与API聚合，负责对外提供RESTful接口。
- `core/`     ：全局配置、应用启动、依赖注入等核心功能。
- `models/`   ：数据模型定义（Pydantic/ORM），用于数据校验与数据库映射。
- `services/` ：业务逻辑层，RAG/Agent等核心功能实现。
- `llms/`     ：大模型适配层，统一对接ChatGLM、Qwen、Llama等。
- `db/`       ：数据库相关代码，连接与初始化等。
- `utils/`    ：工具函数与通用组件。
- `tasks/`    ：异步任务、定时任务等。 