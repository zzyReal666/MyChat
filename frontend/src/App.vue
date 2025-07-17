<script setup>
// ==================== 导入依赖 ====================
import { ref } from 'vue'  // Vue3 的响应式数据引用
import ChatWindow from './components/ChatWindow.vue'  // 聊天窗口组件
import ChatInput from './components/ChatInput.vue'    // 聊天输入组件
import { sendChatMessage } from './api/chat'         // 发送聊天消息的API函数

// ==================== 响应式数据定义 ====================
// 欢迎消息对象，包含角色、文本和引用信息
const welcomeMsg = { role: 'ai', text: '你好！我是智能助手，有什么可以帮你？', references: [] }
// 聊天消息列表，使用ref使其具有响应式特性
const messages = ref([
  welcomeMsg
])
// 加载状态标志，用于控制输入框禁用状态
const loading = ref(false)
// 历史会话列表数据
const historyList = ref([
  { id: 1, title: '与AI的第一次对话' },
  { id: 2, title: 'RAG测试' }
])

// ==================== 事件处理函数 ====================
/**
 * 清空聊天记录
 * 将消息列表重置为只包含欢迎消息
 */
function handleClear() {
  messages.value = [welcomeMsg]
}

/**
 * 发送聊天消息
 * @param {string} question - 用户输入的问题
 */
async function handleSend(question) {
  //1添加到消息列表
  messages.value.push({ role: 'user', text: question })
  //2状态，禁用输入框
  loading.value = true
  
  try {
    // 3端API发送消息
    const res = await sendChatMessage(question)
    // 4 后端返回的是 sources，需要转换为 references 格式
    const references = res.data.sources ? res.data.sources.map(source => ({
      content: source,
      source: '知识库'
    })) : []
    // 5. 将AI回复添加到消息列表
    messages.value.push({
      role: 'ai',
      text: res.data.answer,
      references: references
    })
  } catch (e) {
    // 6示错误信息
    messages.value.push({ role: 'ai', text: '抱歉，出错了：' + (e.response?.data?.detail || e.message), references: [] })
  } finally {
    // 7无论成功失败都要关闭加载状态
    loading.value = false
  }
}
</script>

<template>
  <!-- ==================== 页面根容器 ==================== -->
  <div class="page-root">
    <div class="chat-root-pro3">
      
      <!-- ==================== 左侧边栏 ==================== -->
      <!-- 包含：品牌标识、会话列表、工具栏、设置 -->
      <aside class="sidebar-pro">
        <!-- 品牌区域 -->
        <div class="sidebar-brand">
          <img src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/wechat.svg" class="brand-logo" alt="logo" />
          <div class="brand-title">MyChat<br /><span>智能平台</span></div>
        </div>
        
        <!-- 会话管理区域 -->
        <div class="sidebar-section">
          <div class="section-title">会话</div>
          <!-- 会话列表 -->
          <ul class="session-list">
            <li v-for="item in historyList" :key="item.id" class="session-item">
              <span class="session-dot"></span>{{ item.title }}
            </li>
          </ul>
          <!-- 新建会话按钮 -->
          <button class="add-session-btn">+ 新建会话</button>
        </div>
        
        <!-- 工具栏区域（占位） -->
        <div class="sidebar-section tools-section">
          <div class="section-title">工具栏</div>
          <div class="tool-placeholder">（企业工具区占位）</div>
        </div>
        
        <!-- 设置区域（占位） -->
        <div class="sidebar-section settings-section">
          <div class="section-title">设置</div>
          <div class="settings-placeholder">（设置项占位）</div>
        </div>
      </aside>
      
      <!-- ==================== 主内容区域 ==================== -->
      <!-- 包含：顶部标题栏、聊天窗口、输入区域 -->
      <main class="main-pro">
        <!-- 顶部标题栏 -->
        <header class="main-header">
          <div class="header-title">RAG 智能对话</div>
          <div class="header-actions">
            <button class="header-btn" @click="handleClear">清空会话</button>
            <button class="header-btn">导出记录</button>
          </div>
        </header>
        
        <!-- 聊天消息显示区域 -->
        <section class="chat-area-pro">
          <ChatWindow :messages="messages" />
        </section>
        
        <!-- 底部输入区域 -->
        <footer class="input-footer-pro">
          <ChatInput :disabled="loading" @send="handleSend" />
        </footer>
      </main>
      
      <!-- ==================== 右侧作者信息栏 ==================== -->
      <!-- 包含：头像、个人信息、项目说明 -->
      <aside class="author-info-pro">
        <div class="author-avatar">
          <img src="https://avatars.githubusercontent.com/u/13717656?v=4" alt="作者头像" />
        </div>
        <div class="author-name">张忠源（Zhang Zhongyuan）</div>
        <div class="author-title">Java & AI 开发者</div>
        <div class="author-desc">
          <p>专注于大模型、RAG、Agent、AI 应用开发。<br>热爱开源与技术分享。</p>
          <p><b>邮箱：</b>zhangzhongyuan@example.com</p>
          <p><b>GitHub：</b><a href="https://github.com/zzyReal666" target="_blank">zzyReal666</a></p>
          <p><b>项目说明：</b><br>本项目为个人学习与实践用途，基于 FastAPI + Langchain，支持多大模型的 RAG/Agent 应用，前后端分离，持续优化中。</p>
        </div>
      </aside>
      
    </div>
  </div>
</template>

<!-- ==================== 全局样式 ==================== -->
<!-- 重置浏览器默认样式，确保页面占满整个视口 -->
<style>
html, body, #app {
  width: 100vw;
  height: 100vh;
  margin: 0;
  padding: 0;
  overflow-x: hidden !important;
  box-sizing: border-box;
}
</style>

<!-- ==================== 组件局部样式 ==================== -->
<style scoped>
/* ==================== 页面根容器样式 ==================== */
.page-root {
  width: 100vw;           /* 占满宽度 */
  min-width: 0;           /* 防止内容溢出 */
  height: 100vh;          /* 占满视口高度 */
  display: flex;          /* 弹性布局 */
  align-items: stretch;   /* 子元素拉伸到相同高度 */
  background: #f7f8fa;    /* 浅灰色背景 */
  overflow: hidden;       /* 隐藏溢出内容 */
}

/* ==================== 聊天应用根容器 ==================== */
.chat-root-pro3 {
  display: flex;          /* 水平弹性布局 */
  flex-direction: row;    /* 从左到右排列 */
  height: 100vh;          /* 占满视口高度 */
  width: 100%;           /* 占满视口宽度 */
  min-width: 0;           /* 防止内容溢出 */
  overflow: hidden;       /* 隐藏溢出内容 */
}

/* ==================== 左侧边栏样式 ==================== */
.sidebar-pro {
  width: 270px;           /* 固定宽度 */
  min-width: 200px;       /* 最小宽度 */
  max-width: 320px;       /* 最大宽度 */
  flex-shrink: 0;         /* 不允许收缩 */
  background: #f4f6fa;    /* 浅蓝灰色背景 */
  border-right: 1.5px solid #e5e7eb;  /* 右侧边框 */
  display: flex;          /* 垂直弹性布局 */
  flex-direction: column; /* 从上到下排列 */
  padding: 0;             /* 无内边距 */
  box-sizing: border-box; /* 盒模型计算 */
  height: 100vh;          /* 占满视口高度 */
  min-width: 0;           /* 防止内容溢出 */
  overflow-y: auto;       /* 垂直滚动 */
}

/* ==================== 品牌区域样式 ==================== */
.sidebar-brand {
  display: flex;          /* 水平弹性布局 */
  align-items: center;    /* 垂直居中对齐 */
  padding: 32px 24px 18px 24px;  /* 内边距：上右下左 */
  border-bottom: 1.5px solid #e5e7eb;  /* 底部边框 */
}
.brand-logo {
  width: 38px;            /* 图标宽度 */
  height: 38px;           /* 图标高度 */
  margin-right: 12px;     /* 右侧外边距 */
}
.brand-title {
  font-size: 1.18rem;     /* 字体大小 */
  font-weight: 800;       /* 字体粗细 */
  color: #2563eb;         /* 蓝色文字 */
  line-height: 1.2;       /* 行高 */
}
.brand-title span {
  font-size: 0.98rem;     /* 副标题字体大小 */
  font-weight: 400;       /* 副标题字体粗细 */
  color: #2563eb;         /* 蓝色文字 */
}

/* ==================== 侧边栏区域通用样式 ==================== */
.sidebar-section {
  padding: 18px 24px 0 24px;  /* 内边距：上右下左 */
}
.section-title {
  font-size: 1.02rem;     /* 区域标题字体大小 */
  font-weight: 600;       /* 区域标题字体粗细 */
  color: #2563eb;         /* 蓝色文字 */
  margin-bottom: 10px;    /* 底部外边距 */
  letter-spacing: 1px;    /* 字母间距 */
}

/* ==================== 会话列表样式 ==================== */
.session-list {
  list-style: none;       /* 移除列表样式 */
  padding: 0;             /* 无内边距 */
  margin: 0 0 8px 0;      /* 外边距：上右下左 */
}
.session-item {
  padding: 8px 0 8px 0;   /* 内边距：上右下左 */
  color: #333;            /* 深灰色文字 */
  cursor: pointer;        /* 鼠标指针样式 */
  border-bottom: 1px solid #e5e7eb;  /* 底部边框 */
  font-size: 1.01rem;     /* 字体大小 */
  display: flex;          /* 弹性布局 */
  align-items: center;    /* 垂直居中对齐 */
  transition: background 0.2s;  /* 背景色过渡动画 */
}
.session-item:hover {
  background: #e8f0fe;    /* 悬停时的背景色 */
}
.session-dot {
  display: inline-block;  /* 行内块元素 */
  width: 7px;             /* 圆点宽度 */
  height: 7px;            /* 圆点高度 */
  background: #2563eb;    /* 蓝色背景 */
  border-radius: 50%;     /* 圆形 */
  margin-right: 8px;      /* 右侧外边距 */
}

/* ==================== 新建会话按钮样式 ==================== */
.add-session-btn {
  width: 100%;            /* 占满容器宽度 */
  margin: 10px 0 0 0;     /* 外边距：上右下左 */
  padding: 7px 0;         /* 内边距：上下 */
  background: #2563eb;    /* 蓝色背景 */
  color: #fff;            /* 白色文字 */
  border: none;           /* 无边框 */
  border-radius: 6px;     /* 圆角 */
  font-size: 1rem;        /* 字体大小 */
  font-weight: 600;       /* 字体粗细 */
  cursor: pointer;        /* 鼠标指针样式 */
  transition: background 0.2s;  /* 背景色过渡动画 */
}
.add-session-btn:hover {
  background: #1749b1;    /* 悬停时的深蓝色背景 */
}

/* ==================== 工具栏和设置区域样式 ==================== */
.tools-section, .settings-section {
  margin-top: 18px;       /* 顶部外边距 */
}
.tool-placeholder, .settings-placeholder {
  color: #aaa;            /* 浅灰色文字 */
  font-size: 0.98rem;     /* 字体大小 */
  padding: 8px 0;         /* 内边距：上下 */
}

/* ==================== 主内容区域样式 ==================== */
.main-pro {
  flex: 1 1 auto;           /* 弹性增长，占满剩余空间 */
  flex-shrink: 1;
  min-width: 0;           /* 防止内容溢出 */
  max-width: calc(100vw - 270px - 300px);  /* 最大宽度：视口宽度减去左右边栏 */
  display: flex;          /* 垂直弹性布局 */
  flex-direction: column; /* 从上到下排列 */
  height: 100vh;          /* 占满视口高度 */
  background: #f7f8fa;    /* 浅灰色背景 */
  overflow: hidden;       /* 隐藏溢出内容 */
}

/* ==================== 顶部标题栏样式 ==================== */
.main-header {
  height: 56px;            /* 固定高度 */
  min-height: 56px;       /* 最小高度 */
  max-height: 56px;       /* 最大高度 */
  background: #fff;       /* 白色背景 */
  border-bottom: 1.5px solid #e5e7eb;  /* 底部边框 */
  display: flex;          /* 水平弹性布局 */
  align-items: center;    /* 垂直居中对齐 */
  justify-content: space-between;  /* 两端对齐 */
  padding: 0 32px;        /* 内边距：左右 */
  font-size: 1.15rem;     /* 字体大小 */
  font-weight: 600;       /* 字体粗细 */
  color: #2563eb;         /* 蓝色文字 */
  letter-spacing: 1px;    /* 字母间距 */
  z-index: 2;             /* 层级 */
  box-sizing: border-box; /* 盒模型计算 */
}
.header-title {
  font-size: 1.12rem;     /* 标题字体大小 */
  font-weight: 700;       /* 标题字体粗细 */
}
.header-actions {
  display: flex;          /* 水平弹性布局 */
  gap: 12px;              /* 元素间距 */
}
.header-btn {
  background: #f4f6fa;    /* 浅灰色背景 */
  color: #2563eb;         /* 蓝色文字 */
  border: 1px solid #e5e7eb;  /* 边框 */
  border-radius: 6px;     /* 圆角 */
  padding: 5px 16px;      /* 内边距：上下左右 */
  font-size: 0.98rem;     /* 字体大小 */
  font-weight: 500;       /* 字体粗细 */
  cursor: pointer;        /* 鼠标指针样式 */
  transition: background 0.2s, color 0.2s;  /* 过渡动画 */
}
.header-btn:hover {
  background: #2563eb;    /* 悬停时的蓝色背景 */
  color: #fff;            /* 悬停时的白色文字 */
}

/* ==================== 聊天区域样式 ==================== */
.chat-area-pro {
  flex: 1;                /* 弹性增长，占满剩余空间 */
  min-height: 0;          /* 最小高度 */
  min-width: 0;           /* 最小宽度 */
  overflow-y: auto;       /* 垂直滚动 */
  padding: 0;             /* 无内边距 */
  background: #f7f8fa;    /* 浅灰色背景 */
  box-sizing: border-box; /* 盒模型计算 */
}

/* ==================== 底部输入区域样式 ==================== */
.input-footer-pro {
  height: 70px;            /* 固定高度 */
  min-height: 70px;       /* 最小高度 */
  max-height: 70px;       /* 最大高度 */
  background: #fff;       /* 白色背景 */
  border-top: 1.5px solid #e5e7eb;  /* 顶部边框 */
  padding: 18px 32px 18px 32px;     /* 内边距：上右下左 */
  box-shadow: 0 -2px 8px 0 rgba(60,72,88,0.04);  /* 顶部阴影 */
  z-index: 2;             /* 层级 */
  box-sizing: border-box; /* 盒模型计算 */
  display: flex;          /* 弹性布局 */
  align-items: center;    /* 垂直居中对齐 */
}

/* ==================== 右侧作者信息栏样式 ==================== */
.author-info-pro {
  width: 300px;           /* 固定宽度 */
  min-width: 200px;       /* 最小宽度 */
  max-width: 300px;       /* 最大宽度 */
  flex-shrink: 0;         /* 不允许收缩 */
  background: #fff;       /* 白色背景 */
  border-left: 1.5px solid #e5e7eb;  /* 左侧边框 */
  display: flex;          /* 垂直弹性布局 */
  flex-direction: column; /* 从上到下排列 */
  align-items: center;    /* 水平居中对齐 */
  padding: 32px 18px 18px 18px;      /* 内边距：上右下左 */
  box-sizing: border-box; /* 盒模型计算 */
  height: 100vh;          /* 占满视口高度 */
  min-width: 0;           /* 防止内容溢出 */
  overflow-y: auto;       /* 垂直滚动 */
  font-size: 1.02rem;     /* 字体大小 */
  color: #222;            /* 深灰色文字 */
}

/* ==================== 作者头像样式 ==================== */
.author-avatar img {
  width: 88px;            /* 头像宽度 */
  height: 88px;           /* 头像高度 */
  border-radius: 50%;     /* 圆形 */
  border: 2.5px solid #2563eb;  /* 蓝色边框 */
  margin-bottom: 16px;    /* 底部外边距 */
}

/* ==================== 作者信息文字样式 ==================== */
.author-name {
  font-size: 1.18rem;     /* 姓名字体大小 */
  font-weight: 700;       /* 姓名字体粗细 */
  color: #2563eb;         /* 蓝色文字 */
  margin-bottom: 4px;     /* 底部外边距 */
}
.author-title {
  font-size: 1.02rem;     /* 职业字体大小 */
  color: #2563eb;         /* 蓝色文字 */
  margin-bottom: 12px;    /* 底部外边距 */
}
.author-desc {
  color: #333;            /* 深灰色文字 */
  font-size: 0.98rem;     /* 描述字体大小 */
  margin-top: 8px;        /* 顶部外边距 */
  line-height: 1.7;       /* 行高 */
}
.author-desc a {
  color: #2563eb;         /* 链接颜色 */
  text-decoration: underline;  /* 下划线 */
}

/* ==================== 响应式设计 ==================== */
/* 屏幕宽度小于1200时隐藏作者信息栏 */
@media (max-width: 1200px) {
  .author-info-pro { display: none; }
}

/* 屏幕宽度小于900px时的移动端适配 */
@media (max-width: 900px) {
  .sidebar-pro {
    width: 60px;          /* 收缩侧边栏宽度 */
    min-width: 60px;
    max-width: 60px;
    padding: 0;
  }
  .sidebar-brand, .sidebar-section {
    padding-left: 8px;    /* 减少内边距 */
    padding-right: 8px;
  }
  .main-header, .input-footer-pro {
    padding-left: 8px;    /* 减少内边距 */
    padding-right: 8px;
  }
  .brand-title {
    display: none;        /* 隐藏品牌标题 */
  }
  .section-title {
    font-size: 0.92rem;   /* 减小字体大小 */
  }
}
</style>
