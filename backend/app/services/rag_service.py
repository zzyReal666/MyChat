import os
from langchain_community.embeddings import DashScopeEmbeddings
from langchain_community.vectorstores import FAISS
from langchain_openai import ChatOpenAI
from langchain.chains import RetrievalQA
from langchain.schema import Document
from pydantic import SecretStr

# 1. 加载向量化模型
embeddings = DashScopeEmbeddings(model="text-embedding-v4")

# 2. 构建本地文档库（实际项目可从数据库/文件加载）
docs = ["Langchain是一个用于构建RAG应用的框架。", "RAG结合了检索和生成模型。"]
documents = [Document(page_content=doc) for doc in docs]

# 3. 构建 FAISS 向量库
vector_db = FAISS.from_documents(documents, embeddings)

# 4. 加载大模型（阿里百炼OpenAI兼容接口）

import os

key = os.getenv("DASHSCOPE_API_KEY")
# print(os.getenv("DASHSCOPE_API_KEY"))
if key is not None:
    os.environ["DASHSCOPE_API_KEY"] = key
else:
    raise ValueError("环境变量 DASHSCOPE_API_KEY 未设置！")
base_url = "https://dashscope.aliyuncs.com/compatible-mode/v1"
llm = ChatOpenAI(
    model="qwen-plus", temperature=0, api_key=SecretStr(key), base_url=base_url
)

# 5. 构建RAG链
qa = RetrievalQA.from_chain_type(
    llm=llm, retriever=vector_db.as_retriever(), return_source_documents=True
)


def rag_qa(question: str):
    """
    输入用户问题，返回答案和参考片段
    """
    result = qa({"query": question})
    answer = result["result"]
    sources = [doc.page_content for doc in result["source_documents"]]
    return answer, sources
