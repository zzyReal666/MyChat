#!/bin/bash

# MyChat 开发工作流脚本
# 使用方法: ./scripts/dev-workflow.sh [command] [options]

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
check_branch() {
    local current_branch=$(git branch --show-current)
    echo "当前分支: $current_branch"
}

# 开始新功能开发
start_feature() {
    local feature_name=$1
    
    if [ -z "$feature_name" ]; then
        print_error "请提供功能名称: ./scripts/dev-workflow.sh start-feature <feature-name>"
        exit 1
    fi
    
    print_info "开始新功能开发: $feature_name"
    
    # 确保在develop分支上
    print_info "切换到develop分支..."
    git checkout develop
    git pull origin develop
    
    # 创建功能分支
    print_info "创建功能分支: feature/$feature_name"
    git checkout -b "feature/$feature_name"
    
    print_success "功能分支创建成功！现在可以开始开发了。"
    print_info "开发完成后使用: ./scripts/dev-workflow.sh finish-feature"
}

# 完成功能开发
finish_feature() {
    local current_branch=$(git branch --show-current)
    
    if [[ ! $current_branch =~ ^feature/ ]]; then
        print_error "当前不在功能分支上: $current_branch"
        exit 1
    fi
    
    print_info "完成功能开发: $current_branch"
    
    # 检查是否有未提交的更改
    if [ -n "$(git status --porcelain)" ]; then
        print_warning "检测到未提交的更改，请先提交或暂存更改"
        git status
        exit 1
    fi
    
    # 推送到远程
    print_info "推送到远程仓库..."
    git push origin "$current_branch"
    
    print_success "功能开发完成！"
    print_info "下一步操作:"
    echo "1. 在GitHub上创建Pull Request"
    echo "2. 等待代码审查"
    echo "3. 合并到develop分支"
    echo "4. 删除功能分支"
}

# 开始热修复
start_hotfix() {
    local hotfix_name=$1
    
    if [ -z "$hotfix_name" ]; then
        print_error "请提供热修复名称: ./scripts/dev-workflow.sh start-hotfix <hotfix-name>"
        exit 1
    fi
    
    print_info "开始热修复: $hotfix_name"
    
    # 从main分支创建热修复分支
    print_info "切换到main分支..."
    git checkout main
    git pull origin main
    
    # 创建热修复分支
    print_info "创建热修复分支: hotfix/$hotfix_name"
    git checkout -b "hotfix/$hotfix_name"
    
    print_success "热修复分支创建成功！"
}

# 完成热修复
finish_hotfix() {
    local current_branch=$(git branch --show-current)
    
    if [[ ! $current_branch =~ ^hotfix/ ]]; then
        print_error "当前不在热修复分支上: $current_branch"
        exit 1
    fi
    
    print_info "完成热修复: $current_branch"
    
    # 检查是否有未提交的更改
    if [ -n "$(git status --porcelain)" ]; then
        print_warning "检测到未提交的更改，请先提交或暂存更改"
        git status
        exit 1
    fi
    
    # 推送到远程
    print_info "推送到远程仓库..."
    git push origin "$current_branch"
    
    print_success "热修复完成！"
    print_info "下一步操作:"
    echo "1. 在GitHub上创建Pull Request到main分支"
    echo "2. 同时创建Pull Request到develop分支"
    echo "3. 等待代码审查"
    echo "4. 合并到main和develop分支"
    echo "5. 删除热修复分支"
}

# 提交代码
commit_code() {
    local commit_type=$1
    local commit_message=$2
    
    if [ -z "$commit_type" ] || [ -z "$commit_message" ]; then
        print_error "请提供提交类型和消息: ./scripts/dev-workflow.sh commit <type> <message>"
        echo "提交类型: feat, fix, docs, style, refactor, test, chore"
        exit 1
    fi
    
    print_info "提交代码: $commit_type: $commit_message"
    
    # 添加所有更改
    git add .
    
    # 提交
    git commit -m "$commit_type: $commit_message"
    
    print_success "代码提交成功！"
}

# 显示帮助信息
show_help() {
    echo "MyChat 开发工作流脚本"
    echo ""
    echo "使用方法: ./scripts/dev-workflow.sh [command] [options]"
    echo ""
    echo "命令:"
    echo "  start-feature <name>    开始新功能开发"
    echo "  finish-feature          完成功能开发"
    echo "  start-hotfix <name>     开始热修复"
    echo "  finish-hotfix           完成热修复"
    echo "  commit <type> <message> 提交代码"
    echo "  check-branch            检查当前分支"
    echo "  help                    显示帮助信息"
    echo ""
    echo "提交类型:"
    echo "  feat     - 新功能"
    echo "  fix      - 修复bug"
    echo "  docs     - 文档更新"
    echo "  style    - 代码格式调整"
    echo "  refactor - 代码重构"
    echo "  test     - 测试相关"
    echo "  chore    - 构建过程或辅助工具"
    echo ""
    echo "示例:"
    echo "  ./scripts/dev-workflow.sh start-feature user-authentication"
    echo "  ./scripts/dev-workflow.sh commit feat \"添加用户登录功能\""
    echo "  ./scripts/dev-workflow.sh finish-feature"
}

# 主函数
main() {
    local command=$1
    
    case $command in
        "start-feature")
            start_feature "$2"
            ;;
        "finish-feature")
            finish_feature
            ;;
        "start-hotfix")
            start_hotfix "$2"
            ;;
        "finish-hotfix")
            finish_hotfix
            ;;
        "commit")
            commit_code "$2" "$3"
            ;;
        "check-branch")
            check_branch
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