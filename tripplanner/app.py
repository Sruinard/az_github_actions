from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import os
from dotenv import load_dotenv

load_dotenv()


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def get():
    active_environment = os.environ.get("ACTIVE_ENVIRONMENT", "default")
    return f"Tripplanner running on {active_environment} environment"

if __name__ == "__main__":
    uvicorn.run(app)