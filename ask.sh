#!/usr/bin/env bash
# Uncensored LLM Runner - Linux/macOS Execution Script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODEL_TYPE="gemma"
PROMPT=""
IMAGE_PATH=""
MAX_TOKENS=2048
REASONING_INPUT="off"

show_help() {
  cat << EOF
Uncensored LLM Runner - High-Performance Local AI Execution

Usage:
  ./ask.sh [options] --prompt "Your prompt here"
  ./ask.sh [options] "Your prompt here"

Options:
  -m, --model <gemma|qwen>      Pick model architecture (default: gemma)
                                  • gemma : Gemma 4 E4B OBLITERATED (4.5B Multimodal Text+Vision)
                                  • qwen  : Qwen 2.5 Coder 7B Abliterated (7.0B Claude Distilled Code)
  -r, --reasoning <off|low|medium|high|on>
                                Set thinking/reasoning effort level (default: off)
                                  • off    : Fast direct answer starting on line 1
                                  • low    : Minimal Chain-of-Thought reasoning
                                  • medium : Balanced Chain-of-Thought reasoning
                                  • high   : Deep reasoning for complex math/logic
  -i, --image <path>            Path to image file for vision analysis (Gemma model)
  -n, --max-tokens <int>        Maximum generation tokens limit (default: 2048)
  -h, --help                    Show this help message and exit

Examples:
  ./ask.sh --model gemma --prompt "Explain binary license validation."
  ./ask.sh --model qwen --prompt "Write a Python JWT validation script."
  ./ask.sh --model gemma --reasoning high --prompt "Solve this complex logic puzzle."
  ./ask.sh --model gemma --image /path/to/diagram.jpg --prompt "Describe this image."
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --help|-h)
      show_help
      ;;
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
      REASONING_INPUT="$2"
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
  show_help
fi

# Reasoning Effort Mapping
REASONING_ARGS=()
case "$REASONING_INPUT" in
  off)
    REASONING_ARGS=("-rea" "off")
    ;;
  low)
    REASONING_ARGS=("-rea" "on" "--reasoning-effort" "low")
    ;;
  medium)
    REASONING_ARGS=("-rea" "on" "--reasoning-effort" "medium")
    ;;
  high)
    REASONING_ARGS=("-rea" "on" "--reasoning-effort" "high")
    ;;
  on)
    REASONING_ARGS=("-rea" "on")
    ;;
  *)
    REASONING_ARGS=("-rea" "off")
    ;;
esac

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
  "${REASONING_ARGS[@]}" \
  --simple-io \
  --no-display-prompt \
  -st \
  --temp 0.7
