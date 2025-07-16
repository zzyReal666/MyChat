<script setup>
import UserRegister from './components/UserRegister.vue'
</script>

<template>
  <div class="main-bg">
    <div class="main-left">
      <div class="main-brand">
        <img src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/wechat.svg" alt="logo" class="main-logo" />
        <div class="main-title">欢迎使用<br>MyChat 智能平台</div>
        <div class="main-desc">基于Langchain与多大模型的RAG/Agent应用</div>
      </div>
      <div class="main-illus"></div>
    </div>
    <div class="main-right">
      <UserRegister />
    </div>
  </div>
</template>

<style scoped>
.main-bg {
  min-height: 100vh;
  width: 100vw;
  display: flex;
  flex-direction: row;
  background: linear-gradient(135deg, #e0e7ef 60%, #f0f9ff 100%);
  overflow-x: hidden;
}
.main-left {
  flex: 1.2;
  min-width: 320px;
  max-width: 600px;
  background: linear-gradient(135deg, #e0e7ef 60%, #60a5fa 100%);
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: center;
  position: relative;
  padding: 0 0 0 8vw;
  box-sizing: border-box;
}
.main-brand {
  z-index: 2;
  margin-right: 8vw;
  margin-bottom: 32px;
  text-align: right;
  max-width: 480px;
}
.main-logo {
  width: 48px;
  height: 48px;
  margin-bottom: 18px;
}
.main-title {
  color: #2563eb;
  font-size: 2.2rem;
  font-weight: 800;
  line-height: 1.2;
  letter-spacing: 2px;
  margin-bottom: 10px;
}
.main-desc {
  color: #2563eb;
  font-size: 1.1rem;
  font-weight: 400;
  margin-bottom: 8px;
}
.main-illus {
  width: 320px;
  height: 180px;
  margin-right: 8vw;
  background: linear-gradient(135deg, #38bdf8 0%, #60a5fa 100%);
  opacity: 0.9;
  border-radius: 24px;
  box-shadow: 0 4px 24px 0 rgba(60, 72, 88, 0.10);
  max-width: 480px;
}
.main-right {
  flex: 1;
  min-width: 340px;
  max-width: 420px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f7f8fa;
  position: relative;
  z-index: 2;
  padding: 0 2vw;
  box-sizing: border-box;
  margin: 0 auto;
}
@media (max-width: 1600px) {
  .main-left { padding-left: 4vw; }
  .main-brand, .main-illus { margin-right: 4vw; }
}
@media (max-width: 1200px) {
  .main-title { font-size: 1.4rem; }
  .main-brand { margin-right: 2vw; }
  .main-illus { width: 200px; height: 110px; margin-right: 2vw; }
}
@media (max-width: 900px) {
  .main-bg { flex-direction: column; }
  .main-left {
    min-height: 180px;
    flex: none;
    align-items: center;
    justify-content: flex-end;
    padding: 0;
    max-width: 100vw;
  }
  .main-brand, .main-illus { margin-right: 0; text-align: center; }
  .main-title { font-size: 1.1rem; }
  .main-right { min-width: 0; max-width: 98vw; padding: 0 8vw; }
}
@media (max-width: 600px) {
  .main-bg { flex-direction: column; }
  .main-left { min-height: 100px; padding: 0; }
  .main-title { font-size: 1rem; margin-bottom: 6px; }
  .main-desc { font-size: 0.95rem; }
  .main-illus { width: 120px; height: 60px; }
  .main-right { padding: 0 2vw; }
}
html, body {
  width: 100vw;
  min-height: 100vh;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
  box-sizing: border-box;
  background: #f7f8fa;
}
</style>
