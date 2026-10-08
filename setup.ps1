# Automated Setup Script for Windows PowerShell
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ModelsDir = Join-Path $ScriptDir "models"
$BinDir = Join-Path $ScriptDir "bin"

New-Item -ItemType Directory -Force -Path $ModelsDir | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

Write-Host "=== [1/2] Downloading Uncensored GGUF Models ===" -ForegroundColor Green

# Install huggingface_hub if missing
python -c "import huggingface_hub" 2>$null
if ($LASTEXITCODE -ne 0) {
    pip install huggingface_hub
}

python -c "
from huggingface_hub import hf_hub_download
import os

models_dir = r'$ModelsDir'

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

Write-Host "=== [2/2] Downloading pre-built Windows llama-cli.exe ===" -ForegroundColor Green

$CliExe = Join-Path $BinDir "llama-cli.exe"
if (-not (Test-Path $CliExe)) {
    Write-Host "Downloading latest llama.cpp Windows release..."
    $ReleaseUrl = "https://github.com/ggerganov/llama.cpp/releases/latest/download/llama-bin-win-x64.zip"
    $ZipPath = Join-Path $BinDir "llama.zip"
    Invoke-WebRequest -Uri $ReleaseUrl -OutFile $ZipPath
    Expand-Archive -Path $ZipPath -DestinationPath $BinDir -Force
    Remove-Item $ZipPath -Force
}

Write-Host "=== Setup Complete! Run .\ask.ps1 to query models. ===" -ForegroundColor Green
