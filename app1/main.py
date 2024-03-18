from fastapi import FastAPI
import os
import requests
from middleware.request_middleware import RequestContextLogMiddleware

app = FastAPI()

app.add_middleware(RequestContextLogMiddleware)

API = os.environ.get("API", "")

@app.get("/")
def sample_endpoint():
    r = requests.get(f"{API}/api/test")
    return {"data @ app1": r.json()}
