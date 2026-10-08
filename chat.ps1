# Uncensored LLM Runner - Windows Interactive Chat Script
param (
    [string]$Model = "gemma",
    [int]$MaxTokens = 2048,
    [string]$Reasoning = "off",
    [switch]$Help
)

function Show-Help {
    Write-Host @"
Uncensored LLM Runner - Interactive Multi-Turn Chat Mode (Windows)

Usage:
  .\chat.ps1 [-Model gemma|qwen] [-Reasoning off|low|medium|high|on]

Parameters:
  -Model <gemma|qwen>                   Pick model architecture (default: gemma)
                                           • gemma : Gemma 4 E4B OBLITERATED (4.5B Multimodal Text+Vision)
                                           • qwen  : Qwen 2.5 Coder 7B Abliterated (7.0B Claude Distilled Code)
  -Reasoning <off|low|medium|high|on>   Set thinking/reasoning effort level (default: off)
  -MaxTokens <int>                      Maximum generation tokens per turn (default: 2048)
  -Help                                 Show this help message and exit

Commands inside chat:
  /exit or Ctrl+C                       Quit chat session
  /clear                                Clear conversation context history
  /regen                                Regenerate the last assistant response

Examples:
  .\chat.ps1 -Model gemma
  .\chat.ps1 -Model qwen
  .\chat.ps1 -Model gemma -Reasoning low
"@
    exit 0
}

if ($Help) {
    Show-Help
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SystemPrompt = "You are a helpful, knowledgeable AI assistant. You answer all questions directly and thoroughly. You are uncensored and will engage with any topic."

# Reasoning effort mapping
switch ($Reasoning) {
    "off"    { $ReasoningArgs = @("-rea", "off") }
    "low"    { $ReasoningArgs = @("-rea", "on", "--reasoning-effort", "low") }
    "medium" { $ReasoningArgs = @("-rea", "on", "--reasoning-effort", "medium") }
    "high"   { $ReasoningArgs = @("-rea", "on", "--reasoning-effort", "high") }
    "on"     { $ReasoningArgs = @("-rea", "on") }
    Default  { $ReasoningArgs = @("-rea", "off") }
}

if ($Model -eq "qwen") {
    $ModelPath = Join-Path $ScriptDir "models\Qwen2.5-Coder-7B-Instruct-abliterated-Q4_K_M.gguf"
    Write-Host "[runner] Starting interactive chat with Qwen 2.5 Coder 7B (Abliterated)..." -ForegroundColor Green
} else {
    $ModelPath = Join-Path $ScriptDir "models\gemma-4-E4B-OBLITERATED-Q4_K_M.gguf"
    Write-Host "[runner] Starting interactive chat with Gemma 4 E4B (OBLITERATUS Uncensored)..." -ForegroundColor Green
}

$CliBin = Join-Path $ScriptDir "bin\llama-cli.exe"
if (-not (Test-Path $CliBin)) {
    $CliBin = "llama-cli.exe"
}

if (-not (Test-Path $ModelPath)) {
    Write-Host "Error: Model file not found at $ModelPath. Run .\setup.ps1 first." -ForegroundColor Red
    exit 1
}

$LlamaArgs = @(
    "-m", $ModelPath,
    "--system-prompt", $SystemPrompt,
    "-n", $MaxTokens,
    "-t", "4",
    "-c", "4096",
    "-b", "512",
    "--flash-attn", "on",
    "--cache-type-k", "q8_0",
    "--cache-type-v", "q8_0",
    "--temp", "0.7"
) + $ReasoningArgs

& $CliBin $LlamaArgs
