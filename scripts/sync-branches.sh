#!/bin/bash

# MyChat 分支同步脚本
# 使用方法: ./scripts/sync-branches.sh [command] [options]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查当前分支
check_current_branch() {
    local current_branch=$(git branch --show-current)
    echo "当前分支: $current_branch"
}

# 检查分支状态
check_branch_status() {
    print_info "检查分支状态..."
    
    # 获取远程最新信息
    git fetch origin
    
    # 检查main分支状态
    local main_ahead=$(git rev-list --count origin/main..main 2>/dev/null || echo "0")
    local main_behind=$(git rev-list --count main..origin/main 2>/dev/null || echo "0")
    
    # 检查develop分支状态
    local develop_ahead=$(git rev-list --count origin/develop..develop 2>/dev/null || echo "0")
    local develop_behind=$(git rev-list --count develop..origin/develop 2>/dev/null || echo "0")
    
    echo "Main分支状态:"
    echo "  本地领先远程: $main_ahead 个提交"
    echo "  本地落后远程: $main_behind 个提交"
    
    echo "Develop分支状态:"
    echo "  本地领先远程: $develop_ahead 个提交"
    echo "  本地落后远程: $develop_behind 个提交"
    
    # 检查develop与main的差异
    local develop_ahead_main=$(git rev-list --count main..develop 2>/dev/null || echo "0")
    local main_ahead_develop=$(git rev-list --count develop..main 2>/dev/null || echo "0")
    
    echo "分支差异:"
    echo "  Develop领先Main: $develop_ahead_main 个提交"
    echo "  Main领先Develop: $main_ahead_develop 个提交"
}

# 同步develop到main（发布新版本）
sync_develop_to_main() {
    print_info "同步develop到main（发布新版本）..."
    
    # 确保在develop分支上
    git checkout develop
    git pull origin develop
    
    # 检查是否有未提交的更改
    if [ -n "$(git status --porcelain)" ]; then
        print_error "Develop分支有未提交的更改，请先提交"
        git status
        exit 1
    fi
    
    # 切换到main分支
    git checkout main
    git pull origin main
    
    # 合并develop到main
    print_info "合并develop到main..."
    git merge develop --no-ff -m "release: 合并develop到main - $(date +%Y-%m-%d)"
    
    # 推送到远程
    print_info "推送到远程main分支..."
    git push origin main
    
    print_success "Develop已成功同步到Main！"
    print_info "建议创建版本标签: git tag -a v1.0.0 -m 'Release v1.0.0'"
}

# 同步main到develop（热修复后）
sync_main_to_develop() {
    print_info "同步main到develop（热修复后）..."
    
    # 确保在main分支上
    git checkout main
    git pull origin main
    
    # 切换到develop分支
    git checkout develop
    git pull origin develop
    
    # 合并main到develop
    print_info "合并main到develop..."
    git merge main --no-ff -m "sync: 同步main到develop - $(date +%Y-%m-%d)"
    
    # 推送到远程
    print_info "推送到远程develop分支..."
    git push origin develop
    
    print_success "Main已成功同步到Develop！"
}

# 定期同步检查
periodic_sync() {
    print_info "执行定期同步检查..."
    
    # 获取远程最新信息
    git fetch origin
    
    # 检查develop与main的差异
    local develop_ahead_main=$(git rev-list --count main..develop 2>/dev/null || echo "0")
    local main_ahead_develop=$(git rev-list --count develop..main 2>/dev/null || echo "0")
    
    if [ "$develop_ahead_main" -gt 50 ]; then
        print_warning "Develop分支领先Main分支 $develop_ahead_main 个提交，建议发布新版本"
        echo "执行: ./scripts/sync-branches.sh release"
    fi
    
    if [ "$main_ahead_develop" -gt 0 ]; then
        print_warning "Main分支领先Develop分支 $main_ahead_develop 个提交，建议同步"
        echo "执行: ./scripts/sync-branches.sh sync-main"
    fi
    
    if [ "$develop_ahead_main" -le 50 ] && [ "$main_ahead_develop" -eq 0 ]; then
        print_success "分支同步状态良好！"
    fi
}

# 创建发布标签
create_release_tag() {
    local version=$1
    
    if [ -z "$version" ]; then
        print_error "请提供版本号: ./scripts/sync-branches.sh tag <version>"
        echo "示例: ./scripts/sync-branches.sh tag v1.0.0"
        exit 1
    fi
    
    print_info "创建发布标签: $version"
    
    # 确保在main分支上
    git checkout main
    git pull origin main
    
    # 创建标签
    git tag -a "$version" -m "Release $version"
    
    # 推送标签
    git push origin "$version"
    
    print_success "标签 $version 创建成功！"
}

# 显示帮助信息
show_help() {
    echo "MyChat 分支同步脚本"
    echo ""
    echo "使用方法: ./scripts/sync-branches.sh [command] [options]"
    echo ""
    echo "命令:"
    echo "  status              检查分支状态"
    echo "  release             同步develop到main（发布新版本）"
    echo "  sync-main           同步main到develop（热修复后）"
    echo "  periodic            定期同步检查"
    echo "  tag <version>       创建发布标签"
    echo "  help                显示帮助信息"
    echo ""
    echo "同步策略:"
    echo "  - 发布时：develop → main"
    echo "  - 热修复后：main → develop"
    echo "  - 定期检查：监控分支差异"
    echo ""
    echo "示例:"
    echo "  ./scripts/sync-branches.sh status"
    echo "  ./scripts/sync-branches.sh release"
    echo "  ./scripts/sync-branches.sh tag v1.0.0"
}

# 主函数
main() {
    local command=$1
    
    case $command in
        "status")
            check_branch_status
            ;;
        "release")
            sync_develop_to_main
            ;;
        "sync-main")
            sync_main_to_develop
            ;;
        "periodic")
            periodic_sync
            ;;
        "tag")
            create_release_tag "$2"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            print_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@" 