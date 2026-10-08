#!/usr/bin/env bash
# Uncensored LLM Runner - Interactive Chat Script (Linux/macOS)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODEL_TYPE="gemma"
MAX_TOKENS=2048
REASONING_INPUT="off"

show_help() {
  cat << EOF
Uncensored LLM Runner - Interactive Multi-Turn Chat Mode

Usage:
  ./chat.sh [options]

Options:
  -m, --model <gemma|qwen>      Pick model architecture (default: gemma)
                                  • gemma : Gemma 4 E4B OBLITERATED (4.5B Multimodal Text+Vision)
                                  • qwen  : Qwen 2.5 Coder 7B Abliterated (7.0B Claude Distilled Code)
  -r, --reasoning <off|low|medium|high|on>
                                Set thinking/reasoning effort level (default: off)
  -n, --max-tokens <int>        Maximum generation tokens per turn (default: 2048)
  -h, --help                    Show this help message and exit

Commands inside chat:
  /exit or Ctrl+C               Quit chat session
  /clear                        Clear conversation context history
  /regen                        Regenerate the last assistant response

Examples:
  ./chat.sh --model gemma
  ./chat.sh --model qwen
  ./chat.sh --model gemma --reasoning low
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
    --max-tokens|-n)
      MAX_TOKENS="$2"
      shift 2
      ;;
    --reasoning|-r)
      REASONING_INPUT="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

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
  echo "[runner] Starting interactive chat with Qwen 2.5 Coder 7B (Abliterated)..."
else
  MODEL_PATH="$DIR/models/gemma-4-E4B-OBLITERATED-Q4_K_M.gguf"
  echo "[runner] Starting interactive chat with Gemma 4 E4B (OBLITERATUS Uncensored)..."
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
  --system-prompt "$SYSTEM_PROMPT" \
  -n "$MAX_TOKENS" \
  -t 4 \
  -c 4096 \
  -b 512 \
  --flash-attn on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  "${REASONING_ARGS[@]}" \
  --temp 0.7
