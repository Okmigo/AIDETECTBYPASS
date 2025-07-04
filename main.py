from fastapi import FastAPI
from pydantic import BaseModel
from transformers import GPT2LMHeadModel, GPT2Tokenizer
import torch

app = FastAPI(
    title="Text Detector API",
    version="1.0.0",
    servers=[{"url": "https://text-detector-api-1098020914152.us-central1.run.app"}]
)

GPT2_MODEL = GPT2LMHeadModel.from_pretrained("gpt2")
GPT2_TOKENIZER = GPT2Tokenizer.from_pretrained("gpt2")

class TextInput(BaseModel):
    text: str

@app.get("/")
def root():
    return {"status": "ok", "message": "Text Detector API is running."}

@app.get("/ping")
def ping():
    return {"status": "ok"}

@app.post("/detect")
def detect(input: TextInput):
    inputs = GPT2_TOKENIZER.encode(input.text, return_tensors="pt")
    with torch.no_grad():
        loss = GPT2_MODEL(inputs, labels=inputs).loss
    perplexity = torch.exp(loss).item()
    return {"perplexity": perplexity}

@app.get("/debug")
def debug():
    return {"torch_version": torch.__version__}

from fastapi.responses import FileResponse
import os

@app.get("/.well-known/ai-plugin.json")
def plugin_manifest():
    return FileResponse(path=os.path.join(".well-known", "ai-plugin.json"), media_type="application/json")


