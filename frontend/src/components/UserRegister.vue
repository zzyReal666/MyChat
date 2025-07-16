<template>
  <div class="grodio-bg">
    <div class="grodio-card">
      <div class="brand">
        <img src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/wechat.svg" alt="logo" class="logo" />
        <span class="brand-title">MyChat</span>
      </div>
      <h2>注册账号</h2>
      <form @submit.prevent="handleRegister">
        <div class="form-group">
          <label for="username">用户名</label>
          <input id="username" v-model="form.username" required placeholder="请输入用户名" autocomplete="username" />
        </div>
        <div class="form-group">
          <label for="email">邮箱</label>
          <input id="email" v-model="form.email" type="email" required placeholder="请输入邮箱" autocomplete="email" />
        </div>
        <button type="submit" :disabled="loading">
          <span v-if="loading">注册中...</span>
          <span v-else>注册</span>
        </button>
      </form>
      <div v-if="message" :class="{ error: isError, success: !isError }">{{ message }}</div>
      <div class="footer-tip">已有账号？<a href="#" class="login-link">登录</a></div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { createUser } from '../api/user'

const form = ref({
  username: '',
  email: ''
})
const message = ref('')
const isError = ref(false)
const loading = ref(false)

const handleRegister = async () => {
  message.value = ''
  isError.value = false
  loading.value = true
  try {
    await createUser(form.value)
    message.value = '注册成功！'
    form.value.username = ''
    form.value.email = ''
  } catch (err) {
    isError.value = true
    message.value = err.response?.data?.detail || '注册失败'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.grodio-bg {
  min-height: 100vh;
  background: linear-gradient(135deg, #f6f7fb 0%, #e9ecef 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}
.grodio-card {
  background: #fff;
  border-radius: 28px;
  box-shadow: 0 8px 40px 0 rgba(60, 72, 88, 0.13);
  padding: 48px 40px 36px 40px;
  max-width: 420px;
  width: 100%;
  text-align: center;
  transition: box-shadow 0.2s;
  position: relative;
  border: 1.5px solid #f0f1f3;
}
@media (max-width: 600px) {
  .grodio-card {
    padding: 28px 6vw 24px 6vw;
    max-width: 99vw;
    border-radius: 16px;
  }
  .brand-title {
    font-size: 1.2rem;
  }
  h2 {
    font-size: 1.05rem;
  }
  input, button {
    font-size: 1rem;
  }
}
.brand {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 18px;
}
.logo {
  width: 36px;
  height: 36px;
  margin-right: 10px;
}
.brand-title {
  font-size: 2rem;
  font-weight: 700;
  color: #ff6f3c;
  letter-spacing: 2px;
}
h2 {
  margin-bottom: 26px;
  color: #222;
  font-weight: 600;
  font-size: 1.3rem;
}
.form-group {
  margin-bottom: 22px;
  text-align: left;
}
label {
  display: block;
  margin-bottom: 7px;
  color: #444;
  font-size: 1rem;
  font-weight: 500;
}
input {
  width: 100%;
  padding: 14px 16px;
  border: none;
  border-radius: 12px;
  font-size: 1.13rem;
  background: #f6f7fb;
  box-shadow: 0 1px 2px 0 rgba(60,72,88,0.04);
  transition: box-shadow 0.2s, background 0.2s;
  outline: none;
}
input:focus {
  background: #fff;
  box-shadow: 0 0 0 2px #ff6f3c33;
}
button {
  width: 100%;
  padding: 14px 0;
  background: linear-gradient(90deg, #ff6f3c 60%, #38bdf8 100%);
  color: #fff;
  font-size: 1.15rem;
  font-weight: 700;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  margin-top: 8px;
  transition: background 0.2s, opacity 0.2s;
  box-shadow: 0 2px 8px 0 rgba(255,111,60,0.08);
  letter-spacing: 1px;
}
button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}
button:hover:not(:disabled) {
  background: linear-gradient(90deg, #38bdf8 0%, #ff6f3c 100%);
}
.error {
  color: #e74c3c;
  margin-top: 18px;
  font-size: 1rem;
}
.success {
  color: #2ecc71;
  margin-top: 18px;
  font-size: 1rem;
}
.footer-tip {
  margin-top: 28px;
  color: #888;
  font-size: 0.98rem;
}
.login-link {
  color: #ff6f3c;
  text-decoration: underline;
  margin-left: 4px;
  font-weight: 500;
}
.login-link:hover {
  color: #38bdf8;
}
</style> 