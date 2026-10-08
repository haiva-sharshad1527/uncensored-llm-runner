# Uncensored Local LLM Suite (Gemma 4 & Qwen 2.5 Coder)

A production-ready, cross-platform local AI setup for running **100% Uncensored** models with zero subscription costs and full privacy.

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

## 🚀 Quick Start Guide

### 💬 1. Multi-Turn Interactive Chat Mode (`chat.sh` / `chat.ps1`)
Launch a continuous terminal chat session that remembers full conversation context across turns:

```bash
# Linux / macOS
./chat.sh --model gemma
./chat.sh --model qwen
```

```powershell
# Windows PowerShell
.\chat.ps1 -Model gemma
.\chat.ps1 -Model qwen
```

### ⚡ 2. Single-Shot Fast Query (`ask.sh` / `ask.ps1`)
Query a model for a single answer and exit immediately (uses 0 RAM when idle):

```bash
# Linux / macOS
./ask.sh --model gemma --prompt "Explain binary license validation."
./ask.sh --model qwen --prompt "Write a Python JWT validation script."
```

---

## ⚙️ Automated Installation

### 🐧 Linux / macOS
```bash
git clone https://github.com/haiva-sharshad1527/uncensored-llm-runner.git
cd uncensored-llm-runner
chmod +x setup.sh ask.sh chat.sh
./setup.sh
```

### 🪟 Windows (PowerShell)
```powershell
git clone https://github.com/haiva-sharshad1527/uncensored-llm-runner.git
cd uncensored-llm-runner
.\setup.ps1
```

---

## 🔒 Privacy & Git Rules

All model weights (`*.gguf`, `models/`, `bin/`) are strictly excluded in `.gitignore` to prevent uploading multi-gigabyte binaries to Git.
