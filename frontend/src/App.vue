<script setup>
import { ref } from 'vue'
import ChatWindow from './components/ChatWindow.vue'
import ChatInput from './components/ChatInput.vue'
import { sendChatMessage } from './api/chat'

const welcomeMsg = { role: 'ai', text: '你好！我是智能助手，有什么可以帮你？', references: [] }
const messages = ref([
  welcomeMsg
])
const loading = ref(false)
const historyList = ref([
  { id: 1, title: '与AI的第一次对话' },
  { id: 2, title: 'RAG测试' }
])

function handleClear() {
  messages.value = [welcomeMsg]
}

async function handleSend(question) {
  messages.value.push({ role: 'user', text: question })
  loading.value = true
  try {
    const res = await sendChatMessage(question)
    messages.value.push({
      role: 'ai',
      text: res.data.answer,
      references: res.data.references || []
    })
  } catch (e) {
    messages.value.push({ role: 'ai', text: '抱歉，出错了：' + (e.response?.data?.detail || e.message), references: [] })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="page-root">
    <div class="chat-root-pro3">
      <!-- Sidebar -->
      <aside class="sidebar-pro">
        <div class="sidebar-brand">
          <img src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/wechat.svg" class="brand-logo" alt="logo" />
          <div class="brand-title">MyChat<br /><span>智能平台</span></div>
        </div>
        <div class="sidebar-section">
          <div class="section-title">会话</div>
          <ul class="session-list">
            <li v-for="item in historyList" :key="item.id" class="session-item">
              <span class="session-dot"></span>{{ item.title }}
            </li>
          </ul>
          <button class="add-session-btn">+ 新建会话</button>
        </div>
        <div class="sidebar-section tools-section">
          <div class="section-title">工具栏</div>
          <div class="tool-placeholder">（企业工具区占位）</div>
        </div>
        <div class="sidebar-section settings-section">
          <div class="section-title">设置</div>
          <div class="settings-placeholder">（设置项占位）</div>
        </div>
      </aside>
      <!-- Main Content -->
      <main class="main-pro">
        <!-- 顶部栏 -->
        <header class="main-header">
          <div class="header-title">RAG 智能对话</div>
          <div class="header-actions">
            <button class="header-btn" @click="handleClear">清空会话</button>
            <button class="header-btn">导出记录</button>
          </div>
        </header>
        <!-- 聊天窗口 -->
        <section class="chat-area-pro">
          <ChatWindow :messages="messages" />
        </section>
        <!-- 输入区 -->
        <footer class="input-footer-pro">
          <ChatInput :disabled="loading" @send="handleSend" />
        </footer>
      </main>
      <!-- Author Info -->
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

<style scoped>
.page-root {
  width: 100vw;
  min-width: 0;
  height: 100vh;
  display: flex;
  align-items: stretch;
  background: #f7f8fa;
  overflow: hidden;
}
.chat-root-pro3 {
  display: flex;
  flex-direction: row;
  height: 100vh;
  width: 100vw;
  min-width: 0;
  overflow: hidden;
}
.sidebar-pro {
  width: 270px;
  min-width: 200px;
  max-width: 320px;
  flex-shrink: 0;
  background: #f4f6fa;
  border-right: 1.5px solid #e5e7eb;
  display: flex;
  flex-direction: column;
  padding: 0;
  box-sizing: border-box;
  height: 100vh;
  min-width: 0;
  overflow-y: auto;
}
.sidebar-brand {
  display: flex;
  align-items: center;
  padding: 32px 24px 18px 24px;
  border-bottom: 1.5px solid #e5e7eb;
}
.brand-logo {
  width: 38px;
  height: 38px;
  margin-right: 12px;
}
.brand-title {
  font-size: 1.18rem;
  font-weight: 800;
  color: #2563eb;
  line-height: 1.2;
}
.brand-title span {
  font-size: 0.98rem;
  font-weight: 400;
  color: #2563eb;
}
.sidebar-section {
  padding: 18px 24px 0 24px;
}
.section-title {
  font-size: 1.02rem;
  font-weight: 600;
  color: #2563eb;
  margin-bottom: 10px;
  letter-spacing: 1px;
}
.session-list {
  list-style: none;
  padding: 0;
  margin: 0 0 8px 0;
}
.session-item {
  padding: 8px 0 8px 0;
  color: #333;
  cursor: pointer;
  border-bottom: 1px solid #e5e7eb;
  font-size: 1.01rem;
  display: flex;
  align-items: center;
  transition: background 0.2s;
}
.session-item:hover {
  background: #e8f0fe;
}
.session-dot {
  display: inline-block;
  width: 7px;
  height: 7px;
  background: #2563eb;
  border-radius: 50%;
  margin-right: 8px;
}
.add-session-btn {
  width: 100%;
  margin: 10px 0 0 0;
  padding: 7px 0;
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}
.add-session-btn:hover {
  background: #1749b1;
}
.tools-section, .settings-section {
  margin-top: 18px;
}
.tool-placeholder, .settings-placeholder {
  color: #aaa;
  font-size: 0.98rem;
  padding: 8px 0;
}

.main-pro {
  flex: 1 1 0%;
  min-width: 0;
  max-width: calc(100vw - 270px - 400px);
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f7f8fa;
  overflow: hidden;
}
.main-header {
  height: 56px;
  min-height: 56px;
  max-height: 56px;
  background: #fff;
  border-bottom: 1.5px solid #e5e7eb;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  font-size: 1.15rem;
  font-weight: 600;
  color: #2563eb;
  letter-spacing: 1px;
  z-index: 2;
  box-sizing: border-box;
}
.header-title {
  font-size: 1.12rem;
  font-weight: 700;
}
.header-actions {
  display: flex;
  gap: 12px;
}
.header-btn {
  background: #f4f6fa;
  color: #2563eb;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  padding: 5px 16px;
  font-size: 0.98rem;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.header-btn:hover {
  background: #2563eb;
  color: #fff;
}

.chat-area-pro {
  flex: 1;
  min-height: 0;
  min-width: 0;
  overflow-y: auto;
  padding: 0;
  background: #f7f8fa;
  box-sizing: border-box;
}
.input-footer-pro {
  height: 70px;
  min-height: 70px;
  max-height: 70px;
  background: #fff;
  border-top: 1.5px solid #e5e7eb;
  padding: 18px 32px 18px 32px;
  box-shadow: 0 -2px 8px 0 rgba(60,72,88,0.04);
  z-index: 2;
  box-sizing: border-box;
  display: flex;
  align-items: center;
}
.author-info-pro {
  width: 300px;
  min-width: 300px;
  max-width: 300px;
  flex-shrink: 0;
  background: #fff;
  border-left: 1.5px solid #e5e7eb;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 32px 18px 18px 18px;
  box-sizing: border-box;
  height: 100vh;
  min-width: 0;
  overflow-y: auto;
  font-size: 1.02rem;
  color: #222;
}
.author-avatar img {
  width: 88px;
  height: 88px;
  border-radius: 50%;
  border: 2.5px solid #2563eb;
  margin-bottom: 16px;
}
.author-name {
  font-size: 1.18rem;
  font-weight: 700;
  color: #2563eb;
  margin-bottom: 4px;
}
.author-title {
  font-size: 1.02rem;
  color: #2563eb;
  margin-bottom: 12px;
}
.author-desc {
  color: #333;
  font-size: 0.98rem;
  margin-top: 8px;
  line-height: 1.7;
}
.author-desc a {
  color: #2563eb;
  text-decoration: underline;
}
@media (max-width: 1200px) {
  .author-info-pro { display: none; }
}
@media (max-width: 900px) {
  .sidebar-pro { width: 60px; min-width: 60px; max-width: 60px; padding: 0; }
  .sidebar-brand, .sidebar-section { padding-left: 8px; padding-right: 8px; }
  .main-header, .input-footer-pro { padding-left: 8px; padding-right: 8px; }
  .brand-title { display: none; }
  .section-title { font-size: 0.92rem; }
}
</style>
