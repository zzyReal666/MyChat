<template>
  <div :class="['chat-message', isUser ? 'user' : 'ai']">
    <div class="avatar">
      <img v-if="isUser" src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/user.svg" alt="user" />
      <img v-else src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/openai.svg" alt="ai" />
    </div>
    <div class="msg-content">
      <div class="msg-text">{{ message.text }}</div>
      <ReferenceList v-if="!isUser && message.references && message.references.length" :references="message.references" />
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'
import ReferenceList from './ReferenceList.vue'
const props = defineProps({
  message: { type: Object, required: true },
  isUser: { type: Boolean, default: false }
})
</script>

<style scoped>
.chat-message {
  display: flex;
  align-items: flex-start;
  margin-bottom: 18px;
  padding: 0 8px;
}
.avatar {
  width: 38px;
  height: 38px;
  margin-right: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.avatar img {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: #f7f8fa;
  border: 1.5px solid #e5e7eb;
}
.msg-content {
  flex: 1;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px 0 rgba(60,72,88,0.06);
  padding: 16px 18px 12px 18px;
  font-size: 1.08rem;
  color: #222;
  word-break: break-word;
  position: relative;
}
.user .msg-content {
  background: linear-gradient(90deg, #e0e7ef 0%, #f0f9ff 100%);
  color: #2563eb;
}
.ai .msg-content {
  background: #fff;
  color: #222;
}
.msg-text {
  margin-bottom: 6px;
  white-space: pre-line;
}
</style> 