#!/usr/bin/env bash
# Automated Setup Script for Linux / macOS
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$DIR/models" "$DIR/bin"

echo "=== [1/3] Downloading Uncensored GGUF Models ==="

python3 -c "
from huggingface_hub import hf_hub_download
import os

models_dir = '$DIR/models'

print('Downloading Qwen 2.5 Coder 7B Abliterated (4.4 GB)...')
hf_hub_download(
    repo_id='bartowski/Qwen2.5-Coder-7B-Instruct-abliterated-GGUF',
    filename='Qwen2.5-Coder-7B-Instruct-abliterated-Q4_K_M.gguf',
    local_dir=models_dir
)

print('Downloading Gemma 4 E4B OBLITERATED (5.0 GB)...')
hf_hub_download(
    repo_id='rdhorner/gemma-4-E4B-it-OBLITERATED-GGUF',
    filename='gemma-4-E4B-OBLITERATED-Q4_K_M.gguf',
    local_dir=models_dir
)

print('Downloading Gemma 4 Vision mmproj (945 MB)...')
try:
    hf_hub_download(
        repo_id='OBLITERATUS/gemma-4-E4B-it-OBLITERATED',
        filename='gemma-4-E4B-it-OBLITERATED-mmproj-f16.gguf',
        local_dir=models_dir
    )
except Exception as e:
    print('mmproj download note:', e)

print('All model downloads finished!')
"

echo "=== [2/3] Checking llama.cpp binary ==="
if ! command -v llama-cli &> /dev/null && [ ! -f "$DIR/bin/llama-cli" ]; then
    echo "llama-cli not found. Compiling native llama-cli..."
    cd "$DIR"
    git clone https://github.com/ggerganov/llama.cpp.git llama-cpp-src
    cd llama-cpp-src
    cmake -B build -DBUILD_SHARED_LIBS=OFF -DGGML_NATIVE=ON
    cmake --build build --config Release --target llama-cli -j$(nproc || sysctl -n hw.ncpu || echo 2)
    cp build/bin/llama-cli "$DIR/bin/"
    cd "$DIR"
    rm -rf llama-cpp-src
fi

chmod +x "$DIR/ask.sh" "$DIR/bin/llama-cli" 2>/dev/null || true
echo "=== [3/3] Setup Complete! Run ./ask.sh to query models. ==="
