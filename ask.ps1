# Uncensored LLM Runner - Windows PowerShell Execution Script
param (
    [string]$Model = "gemma",
    [string]$Prompt = "",
    [string]$Image = "",
    [int]$MaxTokens = 2048,
    [string]$Reasoning = "off"
)

if (-not $Prompt) {
    Write-Host "Usage: .\ask.ps1 -Model gemma|qwen [-Reasoning off|low|medium|high|on] [-MaxTokens 2048] [-Image C:\path\to\image.jpg] -Prompt `"Your prompt here`""
    exit 1
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
    "--simple-io",
    "--no-display-prompt",
    "-st",
    "--temp", "0.7"
) + $ReasoningArgs + $MmprojArgs

& $CliBin $LlamaArgs
