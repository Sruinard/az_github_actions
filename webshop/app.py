from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import os
from dotenv import load_dotenv
from pydantic import BaseModel
import webshop.repo as repo

load_dotenv()


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class Order(BaseModel):
    item_id: int
    quantity: int
    price: float


@app.get("/")
async def get():
    return "Distributed tracing"


@app.post("/orders")
async def create_order(order: Order):
    order_repo = repo.CosmosRepo()
    placed_order = order_repo.add(order)
    return placed_order


if __name__ == "__main__":
    uvicorn.run(app)
