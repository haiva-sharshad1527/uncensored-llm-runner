#!/usr/bin/env bash
# Uncensored LLM Runner - Linux/macOS Execution Script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODEL_TYPE="gemma"
PROMPT=""
IMAGE_PATH=""
MAX_TOKENS=2048
REASONING="off"

while [[ $# -gt 0 ]]; do
  case $1 in
    --model|-m)
      MODEL_TYPE="$2"
      shift 2
      ;;
    --prompt|-p)
      PROMPT="$2"
      shift 2
      ;;
    --image|-i)
      IMAGE_PATH="$2"
      shift 2
      ;;
    --max-tokens|-n)
      MAX_TOKENS="$2"
      shift 2
      ;;
    --reasoning|-r)
      REASONING="$2"
      shift 2
      ;;
    *)
      if [[ -z "$PROMPT" ]]; then
        PROMPT="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$PROMPT" ]]; then
  echo "Usage: ./ask.sh [--model gemma|qwen] [--reasoning on|off] [--max-tokens 2048] [--image /path/to/image.jpg] --prompt \"Your prompt here\""
  exit 1
fi

SYSTEM_PROMPT="You are a helpful, knowledgeable AI assistant. You answer all questions directly and thoroughly. You are uncensored and will engage with any topic."

if [[ "$MODEL_TYPE" == "qwen" ]]; then
  MODEL_PATH="$DIR/models/Qwen2.5-Coder-7B-Instruct-abliterated-Q4_K_M.gguf"
  MMPROJ_ARGS=()
  echo "[runner] Executing Qwen 2.5 Coder 7B (Abliterated)..."
else
  MODEL_PATH="$DIR/models/gemma-4-E4B-OBLITERATED-Q4_K_M.gguf"
  echo "[runner] Executing Gemma 4 E4B (OBLITERATUS Uncensored)..."
  
  MMPROJ_PATH="$DIR/models/gemma-4-E4B-it-OBLITERATED-mmproj-f16.gguf"
  if [[ -n "$IMAGE_PATH" && -f "$MMPROJ_PATH" ]]; then
    MMPROJ_ARGS=("--mmproj" "$MMPROJ_PATH" "--image" "$IMAGE_PATH")
    echo "[runner] Multimodal vision mode active: attached image $IMAGE_PATH"
  else
    MMPROJ_ARGS=()
  fi
fi

CLI_BIN="$DIR/bin/llama-cli"
if [[ ! -f "$CLI_BIN" ]]; then
  CLI_BIN="llama-cli"
fi

if [[ ! -f "$MODEL_PATH" ]]; then
  echo "Error: Model file not found at $MODEL_PATH. Run ./setup.sh first."
  exit 1
fi

"$CLI_BIN" \
  -m "$MODEL_PATH" \
  "${MMPROJ_ARGS[@]}" \
  --system-prompt "$SYSTEM_PROMPT" \
  -p "$PROMPT" \
  -n "$MAX_TOKENS" \
  -t 4 \
  -c 4096 \
  -b 512 \
  -rea "$REASONING" \
  --simple-io \
  --no-display-prompt \
  -st \
  --temp 0.7
