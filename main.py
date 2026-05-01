from fastapi import FastAPI
from stockfish import Stockfish
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # or specify "https://www.chess.com"
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get('/next')
def next_move(fen: str):
    engine = Stockfish('./stockfish')
    engine.set_fen_position(fen)
    return {'move': engine.get_best_move_time()}
