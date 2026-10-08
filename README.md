# Uncensored Local LLM Suite (Gemma 4 & Qwen 2.5 Coder)

A production-ready, cross-platform local AI setup for running **100% Uncensored** models on-demand with zero subscription costs and full privacy.

Supports **Linux, macOS, and Windows** (CPU & ARM64 optimized).

---

## 🌟 Featured Models

1. **Gemma 4 E4B OBLITERATED (`gemma-4-E4B-OBLITERATED-Q4_K_M.gguf` - 5.0 GB)**
   * **Engine:** Google Gemma 4 (4.5B parameters)
   * **Uncensored:** OBLITERATUS v3 SVD-whitened (0% refusal rate)
   * **Multimodal:** Supports text, vision/image input (`--image /path/to/img.jpg`), and audio keyframes.
2. **Qwen 2.5 Coder 7B Abliterated (`Qwen2.5-Coder-7B-Instruct-abliterated-Q4_K_M.gguf` - 4.4 GB)**
   * **Engine:** Qwen 2.5 Coder 7B (Claude 3.5 Sonnet Distilled)
   * **Uncensored:** Bartowski multi-layer abliterated
   * **Specialty:** Elite software engineering, code generation, AppSec & binary analysis.

---

## 🚀 Quick Setup Guide

### 🐧 Linux / macOS
```bash
# 1. Clone the repository
git clone https://github.com/haiva-sharshad1527/uncensored-llm-runner.git
cd uncensored-llm-runner

# 2. Run automated setup (downloads models & compiles native llama-cli)
chmod +x setup.sh ask.sh
./setup.sh

# 3. Query models on-demand
./ask.sh --model gemma --prompt "Explain binary license verification algorithms."
./ask.sh --model qwen --prompt "Write a Python script for JWT token validation."
./ask.sh --model gemma --image /path/to/screenshot.png --prompt "Analyze this diagram."
```

### 🪟 Windows (PowerShell)
```powershell
# 1. Open PowerShell and clone repository
git clone https://github.com/haiva-sharshad1527/uncensored-llm-runner.git
cd uncensored-llm-runner

# 2. Run setup script (downloads pre-built Windows llama-cli.exe and GGUF models)
.\setup.ps1

# 3. Query models on-demand
.\ask.ps1 -Model gemma -Prompt "Explain binary license verification algorithms."
.\ask.ps1 -Model qwen -Prompt "Write a Python script for JWT token validation."
.\ask.ps1 -Model gemma -Image C:\path\to\image.png -Prompt "Analyze this diagram."
```

---

## ⚡ Performance & Resource Optimization

* **Zero Idle RAM:** Models execute single-shot and immediately exit, freeing 100% of system RAM.
* **FlashAttention-2 (`--flash-attn on`):** 3x faster prompt processing ($O(N)$ memory tiles).
* **INT8 KV Cache (`--cache-type-k/v q8_0`):** 50% RAM savings (~1.8 GB reserved context).
* **Physical Thread Pinning (`-t 4`):** Prevents CPU core context-switching thrashing.

---

## 🔒 Privacy & Git Rules

All model weights (`*.gguf`, `models/`, `bin/`) are strictly excluded in `.gitignore` to prevent uploading multi-gigabyte binaries to Git.
