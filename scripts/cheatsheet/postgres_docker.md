# Postgres Docker 启动与常用命令

## 1. 启动Postgres容器
```bash
docker run --name mychat-postgres \
  -e POSTGRES_USER=mychat_user \
  -e POSTGRES_PASSWORD=mychat_password \
  -e POSTGRES_DB=mychat_db \
  -p 5432:5432 \
  -d postgres:14
```
- `mychat_user`、`mychat_password`、`mychat_db` 可根据需要自定义。
- `-p 5432:5432` 将容器的5432端口映射到本机，便于本地开发。

## 2. 进入Postgres容器
```bash
docker exec -it mychat-postgres psql -U mychat_user -d mychat_db
```

## 3. 停止并删除容器
```bash
docker stop mychat-postgres
# 删除容器（慎用，会丢数据）
docker rm mychat-postgres
```

## 4. 查看容器日志
```bash
docker logs mychat-postgres
```

## 5. 其他常用命令
- 查看所有容器：`docker ps -a`
- 查看所有镜像：`docker images`
- 删除镜像：`docker rmi 镜像ID`

---
> 本文件用于记录学习过程中常用的Postgres Docker命令和知识点，便于查阅和复用。 