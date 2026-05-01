FROM alpine:3.23 as stock-fish-builder
ADD https://github.com/official-stockfish/Stockfish/releases/latest/download/stockfish-ubuntu-x86-64.tar /stockfish.tar
RUN apk add wget g++ make && \
    tar -xf stockfish.tar && \
    cd stockfish/src && make -j profile-build ARCH=x86-64
FROM alpine:3.23
COPY . /app
WORKDIR /app
COPY --from=stock-fish-builder /stockfish/src/stockfish .
ENV PATH="/root/.local/bin:$PATH"
RUN apk add --no-cache python3 curl uvicorn && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv sync --frozen
CMD ["uv","run","uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
