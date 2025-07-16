<template>
  <div class="chat-window-pro">
    <div class="chat-history-pro" ref="historyRef">
      <div v-for="(msg, idx) in messages" :key="idx" :class="['msg-row', msg.role === 'user' ? 'right' : 'left']">
        <div class="msg-avatar">
          <img v-if="msg.role === 'user'" src="https://unpkg.com/heroicons@2.0.16/24/solid/user.svg" alt="user" />
          <img v-else src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/openai.svg" alt="ai" />
        </div>
        <div class="msg-bubble">
          <div class="msg-text">{{ msg.text }}</div>
          <ReferenceList v-if="msg.role !== 'user' && msg.references && msg.references.length" :references="msg.references" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, ref, watch, nextTick } from 'vue'
import ReferenceList from './ReferenceList.vue'
const props = defineProps({
  messages: { type: Array, default: () => [] }
})
const historyRef = ref(null)
watch(
  () => props.messages.length,
  async () => {
    await nextTick()
    if (historyRef.value) {
      historyRef.value.scrollTop = historyRef.value.scrollHeight
    }
  }
)
</script>

<style scoped>
.chat-window-pro {
  flex: 1;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: #f7f8fa;
  min-height: 0;
  width: 100%;
}
.chat-history-pro {
  flex: 1;
  overflow-y: auto;
  padding: 32px 0 0 0;
  display: flex;
  flex-direction: column;
  gap: 18px;
  min-height: 0;
}
.msg-row {
  display: flex;
  align-items: flex-end;
  width: 100%;
}
.msg-row.left {
  flex-direction: row;
  justify-content: flex-start;
}
.msg-row.right {
  flex-direction: row-reverse;
  justify-content: flex-end;
}
.msg-avatar {
  width: 38px;
  height: 38px;
  margin: 0 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.msg-avatar img {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: #f7f8fa;
  border: 1.5px solid #e5e7eb;
}
.msg-bubble {
  max-width: 70%;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px 0 rgba(60,72,88,0.10);
  padding: 16px 18px 12px 18px;
  font-size: 1.08rem;
  color: #222;
  word-break: break-word;
  position: relative;
  min-width: 0;
}
.msg-row.right .msg-bubble {
  background: linear-gradient(90deg, #e0e7ef 0%, #f0f9ff 100%);
  color: #2563eb;
  align-items: flex-end;
}
.msg-row.left .msg-bubble {
  background: #fff;
  color: #222;
  align-items: flex-start;
}
.msg-text {
  margin-bottom: 6px;
  white-space: pre-line;
}
</style> 