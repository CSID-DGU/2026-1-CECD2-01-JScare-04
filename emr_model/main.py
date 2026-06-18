from fastapi import FastAPI

from app.api import router


app = FastAPI(
    title="EMR AI Server",
    version="1.0.0"
)

app.include_router(router)