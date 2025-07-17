#!/bin/bash

# MyChat 部署脚本
# 用法: ./deploy.sh [environment] [version]
# 示例: ./deploy.sh staging v1.0
# 示例: ./deploy.sh production v100

set -e  # 遇到错误立即退出

# 颜色定义
RED=undefined0330;31
GREEN='\033;32m'
YELLOW='\331;33mBLUE=0330;34
NC='\330# No Color

# 日志函数
log_info() {
    echo -e ${BLUE}[INFO]${NC} $1
}

log_success() {
    echo -e ${GREEN}[SUCCESS]${NC} $1
}

log_warning() {
    echo -e ${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e ${RED}[ERROR]${NC} $1
}

# 检查参数
if  $# -lt2then
    log_error "用法: $0 [environment] [version]"
    log_error "环境: staging, production"
    log_error 示例: $0taging v100
    exit1
fi

ENVIRONMENT=$1VERSION=$2

# 验证环境参数
if [[$ENVIRONMENT" !=staging &&$ENVIRONMENT" != "production ]];then
    log_error "无效的环境参数: $ENVIRONMENT"
    log_error "支持的环境: staging, production"
    exit 1fi

log_info 开始部署 MyChat 到 $ENVIRONMENT 环境，版本: $VERSION

# 检查必要的工具
check_requirements() {
    log_info检查部署要求..."
    
    # 检查 kubectl
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl 未安装"
        exit1
    fi
    
    # 检查 docker
    if ! command -v docker &> /dev/null; then
        log_error "docker 未安装"
        exit1   fi
    
    log_success 所有要求已满足
}# 构建Docker镜像
build_images() {
    log_info "构建Docker镜像..."
    
    # 构建后端镜像
    log_info "构建后端镜像...    docker build -t mychat-backend:$VERSION ./backend
    docker tag mychat-backend:$VERSION mychat-backend:latest
    
    # 构建前端镜像
    log_info "构建前端镜像...    docker build -t mychat-frontend:$VERSION ./frontend
    docker tag mychat-frontend:$VERSION mychat-frontend:latest
    
    log_success Docker镜像构建完成"
}

# 推送镜像到注册表
push_images() {
    log_info "推送镜像到注册表...
    
    # 设置注册表
    REGISTRY="ghcr.io
    IMAGE_NAME=zzyReal666MyChat"
    
    # 推送后端镜像
    log_info "推送后端镜像..."
    docker tag mychat-backend:$VERSION $REGISTRY/$IMAGE_NAME-backend:$VERSION
    docker tag mychat-backend:$VERSION $REGISTRY/$IMAGE_NAME-backend:latest
    docker push $REGISTRY/$IMAGE_NAME-backend:$VERSION
    docker push $REGISTRY/$IMAGE_NAME-backend:latest
    
    # 推送前端镜像
    log_info "推送前端镜像..."
    docker tag mychat-frontend:$VERSION $REGISTRY/$IMAGE_NAME-frontend:$VERSION
    docker tag mychat-frontend:$VERSION $REGISTRY/$IMAGE_NAME-frontend:latest
    docker push $REGISTRY/$IMAGE_NAME-frontend:$VERSION
    docker push $REGISTRY/$IMAGE_NAME-frontend:latest
    
    log_success 镜像推送完成"
}

# 部署到Kubernetes
deploy_to_k8s() {
    log_info "部署到Kubernetes..."
    
    # 应用Kubernetes配置
    kubectl apply -f deploy/k8s/
    
    # 更新镜像版本
    kubectl set image deployment/backend-deployment backend=mychat-backend:$VERSION
    kubectl set image deployment/frontend-deployment frontend=mychat-frontend:$VERSION
    
    # 等待部署完成
    log_info "等待部署完成..."
    kubectl rollout status deployment/backend-deployment --timeout=300s
    kubectl rollout status deployment/frontend-deployment --timeout=30  
    log_successKubernetes部署完成
}

# 健康检查
health_check() {
    log_info执行健康检查..."
    
    # 等待服务启动
    sleep 30    
    # 检查Pod状态
    log_info "检查Pod状态..."
    kubectl get pods -l app=backend
    kubectl get pods -l app=frontend
    
    # 检查服务状态
    log_info "检查服务状态..."
    kubectl get services
    
    # 检查后端健康状态
    log_info检查后端健康状态..."
    BACKEND_URL=$(kubectl get service backend-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if  -n$BACKEND_URL" ]; then
        curl -f http://$BACKEND_URL:800lth || log_warning "后端健康检查失败  else
        log_warning无法获取后端服务URL"
    fi
    
    log_success 健康检查完成"
}

# 回滚函数
rollback() {
    log_warning开始回滚部署..."
    
    # 回滚到上一个版本
    kubectl rollout undo deployment/backend-deployment
    kubectl rollout undo deployment/frontend-deployment
    
    # 等待回滚完成
    kubectl rollout status deployment/backend-deployment --timeout=300s
    kubectl rollout status deployment/frontend-deployment --timeout=30  
    log_success回滚完成"
}

# 清理函数
cleanup() {
    log_info清理临时资源..."
    
    # 删除本地镜像标签
    docker rmi mychat-backend:$VERSION mychat-backend:latest 2>/dev/null || true
    docker rmi mychat-frontend:$VERSION mychat-frontend:latest 2>/dev/null || true
    
    log_success "清理完成"
}

# 主函数
main() {
    log_info "=== MyChat 部署脚本 ===
    log_info环境: $ENVIRONMENT
    log_info "版本: $VERSION"
    
    # 执行部署步骤
    check_requirements
    build_images
    push_images
    deploy_to_k8s
    health_check
    
    log_success "部署完成！    log_info "访问地址: http://localhost:3000(前端)"
    log_info "API地址: http://localhost:8000 (后端)
}

# 错误处理
traplog_error 部署过程中发生错误，开始回滚..."; rollback; cleanup; exit 1' ERR

# 执行主函数
main "$@" 