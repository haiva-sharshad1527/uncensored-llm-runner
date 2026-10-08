# Uncensored LLM Runner - Windows PowerShell Execution Script
param (
    [string]$Model = "gemma",
    [string]$Prompt = "",
    [string]$Image = "",
    [int]$MaxTokens = 512,
    [string]$Reasoning = "off",
    [switch]$Help
)

function Show-Help {
    Write-Host @"
Uncensored LLM Runner - High-Performance Local AI Execution (Windows)

Usage:
  .\ask.ps1 -Prompt "Your prompt here"
  .\ask.ps1 -Model gemma|qwen [-Reasoning off|low|medium|high|on] -Prompt "Your prompt here"

Parameters:
  -Model <gemma|qwen>                   Pick model architecture (default: gemma)
                                           • gemma : Gemma 4 E4B OBLITERATED (4.5B Multimodal Text+Vision)
                                           • qwen  : Qwen 2.5 Coder 7B Abliterated (7.0B Claude Distilled Code)
  -Reasoning <off|low|medium|high|on>   Set thinking/reasoning effort level (default: off)
                                           • off    : Fast direct answer starting on line 1
                                           • low    : Minimal Chain-of-Thought reasoning
                                           • medium : Balanced Chain-of-Thought reasoning
                                           • high   : Deep reasoning for complex math/logic
  -Image <path>                         Path to image file for vision analysis (Gemma model)
  -MaxTokens <int>                      Maximum generation tokens limit (default: 512)
  -Help                                 Show this help message and exit

Examples:
  .\ask.ps1 -Model gemma -Prompt "Explain binary license validation."
  .\ask.ps1 -Model qwen -Prompt "Write a Python JWT validation script."
  .\ask.ps1 -Model gemma -Reasoning high -Prompt "Solve this complex logic puzzle."
  .\ask.ps1 -Model gemma -Image C:\path\to\diagram.png -Prompt "Describe this image."
"@
    exit 0
}

if ($Help -or (-not $Prompt)) {
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
    $MmprojArgs = @()
    Write-Host "[runner] Executing Qwen 2.5 Coder 7B (Abliterated)..."
} else {
    $ModelPath = Join-Path $ScriptDir "models\gemma-4-E4B-OBLITERATED-Q4_K_M.gguf"
    Write-Host "[runner] Executing Gemma 4 E4B (OBLITERATUS Uncensored)..."

    $MmprojPath = Join-Path $ScriptDir "models\gemma-4-E4B-it-OBLITERATED-mmproj-f16.gguf"
    if ($Image -and (Test-Path $MmprojPath)) {
        $MmprojArgs = @("--mmproj", $MmprojPath, "--image", $Image)
        Write-Host "[runner] Multimodal vision mode active: attached image $Image"
    } else {
        $MmprojArgs = @()
    }
}

$CliBin = Join-Path $ScriptDir "bin\llama-cli.exe"
if (-not (Test-Path $CliBin)) {
    $CliBin = "llama-cli.exe"
}

if (-not (Test-Path $ModelPath)) {
    Write-Host "Error: Model file not found at $ModelPath. Run .\setup.ps1 first."
    exit 1
}

$LlamaArgs = @(
    "-m", $ModelPath,
    "--system-prompt", $SystemPrompt,
    "-p", $Prompt,
    "-n", $MaxTokens,
    "-t", "4",
    "-c", "4096",
    "-b", "512",
    "--flash-attn", "on",
    "--cache-type-k", "q8_0",
    "--cache-type-v", "q8_0",
    "--simple-io",
    "--no-display-prompt",
    "-st",
    "--temp", "0.7"
) + $ReasoningArgs + $MmprojArgs

& $CliBin $LlamaArgs
