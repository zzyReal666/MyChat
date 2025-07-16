<template>
  <div class="reference-list" v-if="references && references.length">
    <div class="ref-title">参考片段</div>
    <div class="ref-cards">
      <div v-for="(ref, idx) in references" :key="idx" class="ref-card">
        <div class="ref-content">{{ ref.content }}</div>
        <div class="ref-meta">
          <span v-if="ref.source">来源：{{ ref.source }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'
const props = defineProps({
  references: { type: Array, default: () => [] }
})
</script>

<style scoped>
.reference-list {
  margin-top: 18px;
  text-align: left;
}
.ref-title {
  font-size: 1.05rem;
  font-weight: 600;
  color: #2563eb;
  margin-bottom: 8px;
}
.ref-cards {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.ref-card {
  background: #f7f8fa;
  border: 1.5px solid #e5e7eb;
  border-radius: 12px;
  padding: 14px 18px 10px 18px;
  min-width: 180px;
  max-width: 320px;
  box-shadow: 0 2px 8px 0 rgba(60,72,88,0.06);
  font-size: 0.98rem;
  color: #333;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.ref-content {
  margin-bottom: 8px;
  word-break: break-all;
}
.ref-meta {
  font-size: 0.92rem;
  color: #888;
  text-align: right;
}
</style> 