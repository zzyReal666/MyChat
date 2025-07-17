from app.services.rag_service import rag_qa
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class ChatRequest(BaseModel):
    question: str


class ChatResponse(BaseModel):
    answer: str
    sources: list[str]


@router.post("/chat", response_model=ChatResponse)
def chat_api(req: ChatRequest):
    answer, sources = rag_qa(req.question)
    return ChatResponse(answer=answer, sources=sources)
