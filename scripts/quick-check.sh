#!/bin/bash

# MyChat 快速代码检查脚本
# 使用方法: ./scripts/quick-check.sh

set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 开始快速代码检查...${NC}"

# 1. Python 代码格式化检查
echo -en "${YELLOW}1. 检查 Python 代码格式化...${NC}"
if black --check backend/; then
    echo -e "${GREEN}✓ Black 检查通过${NC}"
else
    echo -e "${YELLOW}⚠ Black 检查失败，正在自动修复...${NC}"
    black backend/
    echo -e "${GREEN}✓ Black 自动修复完成${NC}"
fi

# 2. Python 代码风格检查
echo -en "${YELLOW}2. 检查 Python 代码风格...${NC}"
if flake8 --format=default --statistics backend/; then
    echo -e "${GREEN}✓ Flake8 检查通过${NC}"
else
    echo -e "${RED}✗ Flake8 检查失败，需要手动修复${NC}"
    exit 1
fi

# 3. 导入排序检查
echo -en "${YELLOW}3. 检查导入排序...${NC}"
if isort --check-only backend/; then
    echo -e "${GREEN}✓ Isort 检查通过${NC}"
else
    echo -e "${YELLOW}⚠ Isort 检查失败，正在自动修复...${NC}"
    isort backend/
    echo -e "${GREEN}✓ Isort 自动修复完成${NC}"
fi

# 4. 前端检查（如果存在）
if [ -d "frontend" ]; then
    echo -en "${YELLOW}4. 检查前端代码...${NC}"
    cd frontend
    if npm run lint 2>/dev/null; then
        echo -e "${GREEN}✓ 前端 ESLint 检查通过${NC}"
    else
        echo -e "${YELLOW}⚠ 前端 ESLint 检查失败或未配置${NC}"
    fi
    cd ..
fi

# 5. 检查 Git 状态
echo -en "${YELLOW}5. 检查 Git 状态...${NC}"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}发现未提交的更改:${NC}"
    git status --short
else
    echo -e "${GREEN}✓ 工作目录干净${NC}"
fi

echo -e "\n${GREEN}🎉 快速检查完成！${NC}"
echo -e "${GREEN}如果所有检查都通过，您可以安全地提交代码了。${NC}" 