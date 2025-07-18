#!/bin/bash

# MyChat 企业级代码提交前检查脚本
# 使用方法: ./scripts/pre-commit-check.sh

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否在项目根目录
if [ ! -f "Makefile" ]; then
    log_error "请在项目根目录运行此脚本"
    exit 1
fi

log_info "开始企业级代码提交前检查..."

# ==================== 1. Git 状态检查 ====================
log_info "1. 检查 Git 状态..."
if [ -n "$(git status --porcelain)" ]; then
    log_warning "发现未提交的更改:"
    git status --short
    echo
else
    log_success "工作目录干净"
fi

# ==================== 2. Python 代码格式化检查 ====================
log_info "2. Python 代码格式化..."

# 检查 black 是否安装
if ! command -v black &> /dev/null; then
    log_error "black 未安装，请运行: pip install black"
    exit 1
fi

# 检查代码格式化
log_info "运行 black 检查..."
if black --check --diff backend/; then
    log_success "Python 代码格式化检查通过"
else
    log_error "Python 代码格式化检查失败，请运行: black backend/"
    exit 1
fi

# ==================== 3. Python 代码风格检查 ====================
log_info "3. 检查 Python 代码风格..."

# 检查 flake8 是否安装
if ! command -v flake8 &> /dev/null; then
    log_error "flake8 未安装，请运行: pip install flake8"
    exit 1
fi

# 运行 flake8 检查
log_info "运行 flake8 检查..."
if flake8 --format=default --statistics backend/; then
    log_success "Python 代码风格检查通过"
else
    log_error "Python 代码风格检查失败"
    exit 1
fi

# ==================== 4. Python 类型检查 ====================
log_info "4. 检查 Python 类型..."
# 检查 mypy 是否安装
if ! command -v mypy &> /dev/null; then
    log_warning "mypy 未安装，跳过类型检查"
    log_info "建议安装: pip install mypy"
else
    log_info "运行 mypy 类型检查..."
    if mypy --ignore-missing-imports backend/; then
        log_success "Python 类型检查通过"
    else
        log_warning "Python 类型检查发现问题，但继续执行"
    fi
fi

# ==================== 5. Python 导入排序检查 ====================
log_info "5. 检查 Python 导入排序..."

# 检查 isort 是否安装
if ! command -v isort &> /dev/null; then
    log_warning "isort 未安装，跳过导入排序检查"
    log_info "建议安装: pip install isort"
else
    log_info "运行 isort 检查..."
    if isort --check-only --diff backend/; then
        log_success "Python 导入排序检查通过"
    else
        log_error "Python 导入排序检查失败，请运行: isort backend/"
        exit 1
    fi
fi

# ==================== 6. 安全扫描 ====================
log_info "6. 运行安全扫描..."

# 检查 bandit 是否安装
if ! command -v bandit &> /dev/null; then
    log_warning "bandit 未安装，跳过安全扫描"
    log_info "建议安装: pip install bandit"
else
    log_info "运行 bandit 安全扫描..."
    if bandit -r backend/ -f json -o backend/bandit-report.json; then
        log_success "安全扫描完成，报告已保存到 backend/bandit-report.json"
    else
        log_warning "安全扫描发现问题，请查看报告"
    fi
fi

# 检查 safety 是否安装
if ! command -v safety &> /dev/null; then
    log_warning "safety 未安装，跳过依赖安全检查"
    log_info "建议安装: pip install safety"
else
    log_info "运行 safety 依赖安全检查..."
    if safety check --json --output backend/safety-report.json; then
        log_success "依赖安全检查完成"
    else
        log_warning "依赖安全检查发现问题，请查看报告"
    fi
fi

# ==================== 7. 前端代码检查 ====================
log_info "7. 检查前端代码..."

if [ -d "frontend" ]; then
    cd frontend
    
    # 检查 node_modules 是否存在
    if [ ! -d "node_modules" ]; then
        log_warning "前端依赖未安装，请运行: cd frontend && npm install"
    else
        # 检查 ESLint
        if npm run lint 2>/dev/null; then
            log_success "前端 ESLint 检查通过"
        else
            log_warning "前端 ESLint 检查失败或未配置"
        fi
        
        # 检查构建
        log_info "检查前端构建..."
        if npm run build 2>/dev/null; then
            log_success "前端构建检查通过"
        else
            log_warning "前端构建检查失败"
        fi
        
        # 检查依赖安全
        log_info "检查前端依赖安全..."
        if npm audit --audit-level=moderate; then
            log_success "前端依赖安全检查通过"
        else
            log_warning "前端依赖安全检查发现问题"
        fi
    fi
    
    cd ..
else
    log_info "未找到前端目录，跳过前端检查"
fi

# ==================== 8. 测试检查 ====================
log_info "8. 运行测试检查..."

# 检查 pytest 是否安装
if ! command -v pytest &> /dev/null; then
    log_warning "pytest 未安装，跳过测试"
    log_info "建议安装: pip install pytest pytest-cov"
else
    if [ -d "backend/tests" ]; then
        log_info "运行后端测试..."
        if cd backend && pytest tests/ -v --tb=short; then
            log_success "后端测试通过"
        else
            log_error "后端测试失败"
            exit 1
        fi
        cd ..
    else
        log_warning "未找到测试目录 backend/tests"
    fi
fi

# ==================== 9. 文档检查 ====================
log_info "9. 检查文档..."
# 检查 README 文件
if [ -f "README.md" ]; then
    log_success "README.md 存在"
else
    log_warning "缺少 README.md 文件"
fi

# 检查 requirements.txt
if [ -f "backend/requirements.txt" ]; then
    log_success "backend/requirements.txt 存在"
else
    log_warning "缺少 backend/requirements.txt 文件"
fi

# ==================== 10. 最终检查 ====================
log_info "10. 最终检查..."

# 检查是否有敏感信息
log_info "检查敏感信息..."
if grep -r "password\|secret\|key\|token" backend/ --exclude-dir=__pycache__ --exclude-dir=.git | grep -v "example\|test\|TODO"; then
    log_warning "发现可能的敏感信息，请检查"
else
    log_success "未发现明显的敏感信息"
fi

# 检查大文件
log_info "检查大文件..."
find . -type f -size +10M -not -path "./.git/*" -not -path "./node_modules/*" | while read file; do
    log_warning "发现大文件: $file"
done

# ==================== 完成 ====================
echo
log_success "🎉 所有检查完成！"
log_info "如果所有检查都通过，您可以安全地提交代码了"
log_info "建议的提交命令:"
echo "  git add ."
echo "  git commit -m \"feat: 你的提交信息\""
echo "  git push origin feature/update-readme"
echo

# 显示当前分支信息
log_info "当前分支信息:"
git branch --show-current
git log --oneline -3 