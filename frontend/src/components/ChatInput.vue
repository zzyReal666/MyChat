<template>
  <div class="input-box-pro">
    <textarea
      v-model="input"
      :disabled="disabled"
      class="input-textarea"
      placeholder="请输入你的问题..."
      rows="1"
      @keydown.enter.exact.prevent="onSend"
      @keydown.shift.enter.stop
      @input="autoResize"
    ></textarea>
    <button class="send-btn" :disabled="disabled || !input.trim()" @click="onSend">发送</button>
  </div>
</template>

<script setup>
import { ref, defineProps, defineEmits, nextTick } from 'vue'
const props = defineProps({ disabled: Boolean })
const emit = defineEmits(['send'])
const input = ref('')
function onSend() {
  if (!input.value.trim() || props.disabled) return
  emit('send', input.value.trim())
  input.value = ''
  nextTick(() => autoResize())
}
function autoResize() {
  const ta = document.querySelector('.input-textarea')
  if (ta) {
    ta.style.height = 'auto'
    ta.style.height = ta.scrollHeight + 'px'
  }
}
</script>

<style scoped>
.input-box-pro {
  display: flex;
  align-items: flex-end;
  width: 100%;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px 0 rgba(60,72,88,0.08);
  padding: 8px 12px 8px 16px;
  gap: 12px;
}
.input-textarea {
  flex: 1;
  min-height: 36px;
  max-height: 120px;
  border: none;
  outline: none;
  resize: none;
  font-size: 1.08rem;
  border-radius: 8px;
  padding: 8px 12px;
  background: #f7f8fa;
  color: #222;
  box-sizing: border-box;
  transition: box-shadow 0.2s;
  box-shadow: 0 1px 4px 0 rgba(60,72,88,0.04);
}
.input-textarea:disabled {
  background: #f3f6fa;
  color: #aaa;
}
.send-btn {
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 1.08rem;
  font-weight: 600;
  padding: 8px 22px;
  cursor: pointer;
  transition: background 0.2s;
  box-shadow: 0 1px 4px 0 rgba(60,72,88,0.04);
}
.send-btn:disabled {
  background: #bcd2fa;
  color: #fff;
  cursor: not-allowed;
}
.send-btn:not(:disabled):hover {
  background: #1749b1;
}
</style> 