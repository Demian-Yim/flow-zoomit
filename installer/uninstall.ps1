#requires -Version 5.1
<#
.SYNOPSIS
  FLOW: AX디자인연구소 — ZoomIt 제거 스크립트
#>

[CmdletBinding()]
param([switch]$Silent)

$ErrorActionPreference = 'SilentlyContinue'

function Write-Banner {
    Write-Host ''
    Write-Host ('═' * 64) -ForegroundColor Cyan
    Write-Host '   FLOW: AX디자인연구소 — ZoomIt 제거' -ForegroundColor White
    Write-Host ('═' * 64) -ForegroundColor Cyan
    Write-Host ''
}

function Write-Footer {
    Write-Host ''
    Write-Host ('─' * 64) -ForegroundColor DarkGray
    Write-Host '   FLOW: AX디자인연구소' -ForegroundColor White
    Write-Host '   by AI 코디네이터 임정훈 소장' -ForegroundColor Gray
    Write-Host '   🌐 https://flowdesign.ai.kr' -ForegroundColor Cyan
    Write-Host '   © 2026 FLOW: AX디자인연구소 All Rights Reserved.' -ForegroundColor DarkGray
    Write-Host ('─' * 64) -ForegroundColor DarkGray
    Write-Host ''
}

Write-Banner

$AppName    = 'FLOW-ZoomIt'
$InstallDir = Join-Path $env:LOCALAPPDATA $AppName

# 1. 프로세스 종료
Write-Host '[1/4] ZoomIt 프로세스 종료 ...' -ForegroundColor Yellow
Get-Process -Name 'ZoomIt*' | Stop-Process -Force
Start-Sleep -Milliseconds 500
Write-Host '      완료' -ForegroundColor Green

# 2. 바로가기 제거
Write-Host '[2/4] 바로가기 제거 ...' -ForegroundColor Yellow
$StartMenuDir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\FLOW-ZoomIt'
$DesktopLnk   = Join-Path ([Environment]::GetFolderPath('Desktop')) 'FLOW ZoomIt.lnk'
$StartupLnk   = Join-Path ([Environment]::GetFolderPath('Startup')) 'FLOW ZoomIt.lnk'

if (Test-Path $StartMenuDir) { Remove-Item $StartMenuDir -Recurse -Force }
if (Test-Path $DesktopLnk)   { Remove-Item $DesktopLnk -Force }
if (Test-Path $StartupLnk)   { Remove-Item $StartupLnk -Force }
Write-Host '      완료' -ForegroundColor Green

# 3. 레지스트리 정리 여부 묻기
Write-Host '[3/4] 레지스트리 설정 처리 ...' -ForegroundColor Yellow
if ($Silent) {
    $keepRegistry = $true
} else {
    Write-Host ''
    Write-Host '   ZoomIt 단축키·폰트 설정 (HKCU\Software\Sysinternals\ZoomIt)을' -ForegroundColor White
    Write-Host '   유지하시겠습니까? (재설치 시 동일 설정 자동 복원)' -ForegroundColor White
    $answer = Read-Host '   유지=Y / 삭제=N (기본 Y)'
    $keepRegistry = ($answer -ne 'N' -and $answer -ne 'n')
}

if (-not $keepRegistry) {
    Remove-Item 'HKCU:\Software\Sysinternals\ZoomIt' -Recurse -Force
    Write-Host '      레지스트리 삭제 완료' -ForegroundColor Green
} else {
    Write-Host '      레지스트리 유지' -ForegroundColor Green
}

# 4. 파일 삭제
Write-Host '[4/4] 설치 파일 삭제 ...' -ForegroundColor Yellow
if (Test-Path $InstallDir) {
    # 자기 자신(uninstall.ps1)은 락이 걸려 있을 수 있으니, schtasks로 지연 삭제
    $deferScript = @"
Start-Sleep -Seconds 2
Remove-Item -Recurse -Force '$InstallDir'
"@
    $tempDefer = Join-Path $env:TEMP 'flow-zoomit-defer-delete.ps1'
    Set-Content -Path $tempDefer -Value $deferScript -Encoding UTF8
    Start-Process -FilePath 'powershell.exe' -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-WindowStyle','Hidden','-File',$tempDefer
}
Write-Host '      완료 (설치 폴더는 2초 뒤 삭제됨)' -ForegroundColor Green

Write-Host ''
Write-Host '━━━ 제거 완료 ━━━' -ForegroundColor Green

Write-Footer

if (-not $Silent) {
    Read-Host '엔터를 누르면 창을 닫습니다'
}
