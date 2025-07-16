import axios from 'axios';

// 创建用户API
export function createUser(data) {
  // 注意：后端服务地址如有变化请同步修改
  return axios.post('http://localhost:8000/api/user/users/', data);
} 