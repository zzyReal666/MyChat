import axios from 'axios';

// 发送聊天消息，获取大模型答案和参考片段
export function sendChatMessage(question) {
  return axios.post('/api/chat', { question });
} 