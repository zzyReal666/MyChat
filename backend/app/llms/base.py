"""
大模型适配基类，所有模型适配器需继承本类。
"""
from abc import ABC, abstractmethod
from typing import Optional

class BaseLLM(ABC):
    @abstractmethod
    def chat(self, prompt: str, history: Optional[list] = None) -> str:
        """
        与大模型对话的统一接口。
        :param prompt: 用户输入
        :param history: 历史对话
        :return: 模型回复
        """
        pass 