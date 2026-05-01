#requires -Version 5.1
<#
.SYNOPSIS
  FLOW ZoomIt — Hugging Face Spaces 자동 배포 스크립트
.DESCRIPTION
  hf CLI 가 인증되어 있어야 합니다 (hf auth login).
  본 저장소 루트에서 실행:
      .\docs\deploy-hf.ps1 -User <your-hf-username>
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$User,
    [string]$SpaceName = 'flow-zoomit',
    [string]$Message = 'Deploy from FLOW ZoomIt repo'
)

$ErrorActionPreference = 'Stop'

# 1) 인증 상태 확인
Write-Host '[1/4] HF auth check...' -ForegroundColor Yellow
$auth = & hf auth whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  로그인이 필요합니다 / Authentication required:" -ForegroundColor Red
    Write-Host '    hf auth login' -ForegroundColor White
    exit 1
}
Write-Host "  Logged in as: $auth" -ForegroundColor Green

# 2) Space 존재 확인 / 없으면 생성
$repo = "$User/$SpaceName"
Write-Host "[2/4] Checking space: $repo ..." -ForegroundColor Yellow
$exists = & hf repo info $repo --repo-type=space 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host '  Creating new static space...' -ForegroundColor Yellow
    & hf repo create $repo --type=space --space_sdk=static
    if ($LASTEXITCODE -ne 0) {
        Write-Host '  Failed to create space.' -ForegroundColor Red
        exit 1
    }
}
Write-Host "  OK · https://huggingface.co/spaces/$repo" -ForegroundColor Green

# 3) 업로드
Write-Host '[3/4] Uploading repo content...' -ForegroundColor Yellow
$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot
try {
    & hf upload $repo . . --repo-type=space --commit-message="$Message"
} finally {
    Pop-Location
}
if ($LASTEXITCODE -ne 0) {
    Write-Host '  Upload failed.' -ForegroundColor Red
    exit 1
}

# 4) 결과
Write-Host '[4/4] Done.' -ForegroundColor Green
Write-Host ''
Write-Host "  Space URL: https://huggingface.co/spaces/$repo" -ForegroundColor Cyan
Write-Host ''
