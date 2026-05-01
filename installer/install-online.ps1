#requires -Version 5.1
<#
.SYNOPSIS
  FLOW: AX 디자인연구소 — ZoomIt v11.0 온라인 설치 스크립트
  Online installer that downloads ZoomIt directly from Microsoft Sysinternals Live.
.DESCRIPTION
  - Microsoft Sysinternals Live 에서 ZoomIt64.exe 직접 다운로드
  - 본 저장소에 ZoomIt 바이너리 미포함 → 라이선스 안전 (재배포 회피)
  - 그 외 동작은 install.ps1 와 동일
#>
[CmdletBinding()]
param(
    [switch]$Silent,
    [switch]$NoStartup
)

$ErrorActionPreference = 'Stop'

function Write-Banner {
    $line = '═' * 64
    Write-Host ''
    Write-Host $line -ForegroundColor Cyan
    Write-Host '   FLOW: AX 디자인연구소 — ZoomIt 온라인 설치' -ForegroundColor White
    Write-Host '   Online installer · downloads ZoomIt v11.0 from Microsoft' -ForegroundColor Gray
    Write-Host $line -ForegroundColor Cyan
    Write-Host ''
}
function Write-Footer {
    $line = '─' * 64
    Write-Host ''
    Write-Host $line -ForegroundColor DarkGray
    Write-Host '   FLOW: AX 디자인연구소 — FLOW: AX Design Lab' -ForegroundColor White
    Write-Host '   by AI 코디네이터 임정훈 소장' -ForegroundColor Gray
    Write-Host '   🌐 https://flowdesign.ai.kr' -ForegroundColor Cyan
    Write-Host '   © 2026 FLOW: AX 디자인연구소 All Rights Reserved.' -ForegroundColor DarkGray
    Write-Host $line -ForegroundColor DarkGray
    Write-Host ''
}

Write-Banner

$AppName    = 'FLOW-ZoomIt'
$InstallDir = Join-Path $env:LOCALAPPDATA $AppName
$ExeName    = 'ZoomIt64.exe'
$ExePath    = Join-Path $InstallDir $ExeName
$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$DownloadUrl = 'https://live.sysinternals.com/ZoomIt64.exe'

# === 1. 다운로드 ===
Write-Host '[1/7] ZoomIt v11.0 다운로드 / Downloading...' -ForegroundColor Yellow
Write-Host "       URL: $DownloadUrl" -ForegroundColor DarkGray
$tmpDownload = Join-Path $env:TEMP "FLOW-ZoomIt-download-$(Get-Random).exe"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $tmpDownload -UseBasicParsing
    $size = (Get-Item $tmpDownload).Length
    Write-Host "       완료 / Done — $([Math]::Round($size/1MB,2)) MB" -ForegroundColor Green
} catch {
    Write-Host "[오류 / Error] 다운로드 실패: $_" -ForegroundColor Red
    Write-Host "       네트워크를 확인하거나 오프라인 설치(install.ps1)를 사용하세요." -ForegroundColor Gray
    Write-Footer
    if (-not $Silent) { Read-Host 'Enter 종료' }
    exit 1
}

# === 2. 기존 ZoomIt 종료 ===
Write-Host '[2/7] 실행 중인 ZoomIt 종료 / Stopping running ZoomIt...' -ForegroundColor Yellow
Get-Process -Name 'ZoomIt*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
Write-Host '       완료 / Done' -ForegroundColor Green

# === 3. 파일 배치 ===
Write-Host "[3/7] 파일 복사 / Copying to: $InstallDir" -ForegroundColor Yellow
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null }
Move-Item -Path $tmpDownload -Destination $ExePath -Force

# about.html (이 스크립트와 같은 위치에 있다면 함께 복사)
$aboutSrc = Join-Path (Split-Path -Parent $ScriptDir) 'about.html'
$aboutDst = Join-Path $InstallDir 'about.html'
if (Test-Path $aboutSrc) {
    Copy-Item $aboutSrc $aboutDst -Force
    # 스크린샷 폴더도 함께
    $shotsSrc = Join-Path (Split-Path -Parent $ScriptDir) 'screenshots'
    if (Test-Path $shotsSrc) {
        Copy-Item $shotsSrc -Destination $InstallDir -Recurse -Force
    }
}
Write-Host '       완료 / Done' -ForegroundColor Green

# === 4. 레지스트리: EULA · 단축키 · 트레이 · 펜 ===
Write-Host '[4/7] 레지스트리 설정 / Registry configuration...' -ForegroundColor Yellow
$RegPath = 'HKCU:\Software\Sysinternals\ZoomIt'
if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }

Set-ItemProperty $RegPath -Name 'EulaAccepted'      -Value 1     -Type DWord
Set-ItemProperty $RegPath -Name 'OptionsShown'      -Value 1     -Type DWord
Set-ItemProperty $RegPath -Name 'FilePath'          -Value "`"$ExePath`"" -Type String
Set-ItemProperty $RegPath -Name 'ToggleKey'         -Value 0x231 -Type DWord
Set-ItemProperty $RegPath -Name 'DrawToggleKey'     -Value 0x232 -Type DWord
Set-ItemProperty $RegPath -Name 'BreakTimerKey'     -Value 0x233 -Type DWord
Set-ItemProperty $RegPath -Name 'LiveZoomToggleKey' -Value 0x234 -Type DWord
Set-ItemProperty $RegPath -Name 'ShowTrayIcon'      -Value 1     -Type DWord
if (-not (Get-ItemProperty $RegPath -Name 'FontScale' -ErrorAction SilentlyContinue)) {
    Set-ItemProperty $RegPath -Name 'FontScale' -Value 30 -Type DWord
}
if (-not (Get-ItemProperty $RegPath -Name 'PenColor' -ErrorAction SilentlyContinue)) {
    Set-ItemProperty $RegPath -Name 'PenColor' -Value 0xFF -Type DWord
}
Set-ItemProperty $RegPath -Name 'PenWidth' -Value 15 -Type DWord
Write-Host '       완료 / Done' -ForegroundColor Green

# === 5. 폰트: 나눔바른펜 Bold ===
Write-Host '[5/7] 기본 폰트 / Default font: 나눔바른펜 Bold...' -ForegroundColor Yellow
$logfont = New-Object byte[] 92
function Write-Int32LE { param($buf, $offset, [int]$value)
    [System.BitConverter]::GetBytes($value) | ForEach-Object -Begin { $i = 0 } -Process { $buf[$offset + $i] = $_; $i++ }
}
Write-Int32LE $logfont 0  -41
Write-Int32LE $logfont 16 700
$logfont[23] = 129    # HANGEUL_CHARSET
$logfont[26] = 4      # ANTIALIASED_QUALITY
$faceBytes = [System.Text.Encoding]::Unicode.GetBytes('나눔바른펜')
[Array]::Copy($faceBytes, 0, $logfont, 28, $faceBytes.Length)
Set-ItemProperty $RegPath -Name 'Font' -Value $logfont -Type Binary
Write-Host '       완료 / Done' -ForegroundColor Green

# === 6. 바로가기 ===
Write-Host '[6/7] 바로가기 / Shortcuts...' -ForegroundColor Yellow
$WshShell = New-Object -ComObject WScript.Shell
function New-Shortcut { param([string]$Path, [string]$Target, [string]$Description)
    if (Test-Path $Path) { Remove-Item $Path -Force }
    $sc = $WshShell.CreateShortcut($Path)
    $sc.TargetPath = $Target
    $sc.Description = $Description
    $sc.WorkingDirectory = Split-Path -Parent $Target
    $sc.Save()
}
$StartMenuDir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\FLOW-ZoomIt'
if (-not (Test-Path $StartMenuDir)) { New-Item -ItemType Directory -Path $StartMenuDir -Force | Out-Null }
New-Shortcut (Join-Path $StartMenuDir 'FLOW ZoomIt.lnk') $ExePath 'FLOW: AX 디자인연구소 — ZoomIt'
if (Test-Path $aboutDst) {
    New-Shortcut (Join-Path $StartMenuDir 'FLOW ZoomIt 정보.lnk') $aboutDst '제작 배경·단축키·라이선스'
}
New-Shortcut (Join-Path ([Environment]::GetFolderPath('Desktop')) 'FLOW ZoomIt.lnk') $ExePath 'FLOW: AX 디자인연구소 — ZoomIt'
if (-not $NoStartup) {
    New-Shortcut (Join-Path ([Environment]::GetFolderPath('Startup')) 'FLOW ZoomIt.lnk') $ExePath 'FLOW ZoomIt 자동 실행'
}
Write-Host '       완료 / Done' -ForegroundColor Green

# === 7. 실행 + 제거 도구 배포 ===
Write-Host '[7/7] ZoomIt 실행 / Launching ZoomIt...' -ForegroundColor Yellow
Start-Process -FilePath $ExePath
Start-Sleep -Milliseconds 800

# uninstall.ps1 + Uninstall.bat 도 InstallDir 에 복사
$uninstallSrc = Join-Path $ScriptDir 'uninstall.ps1'
if (Test-Path $uninstallSrc) {
    Copy-Item $uninstallSrc (Join-Path $InstallDir 'uninstall.ps1') -Force
}
$uninstallBat = @'
@echo off
chcp 65001 > nul
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0uninstall.ps1"
pause
'@
Set-Content -Path (Join-Path $InstallDir 'Uninstall.bat') -Value $uninstallBat -Encoding UTF8
Write-Host '       완료 / Done — tray icon ready.' -ForegroundColor Green

Write-Host ''
Write-Host '━━━ 설치 완료 / Installation complete ━━━' -ForegroundColor Green
Write-Host ''
Write-Host 'Hotkeys:' -ForegroundColor White
Write-Host '  Ctrl+1..Ctrl+8, Ctrl+Shift+6  · 9 features ready' -ForegroundColor Gray
Write-Host 'Info / 정보:' -ForegroundColor White
Write-Host '  Start Menu → FLOW-ZoomIt → "FLOW ZoomIt 정보"' -ForegroundColor Gray
Write-Host 'Uninstall:' -ForegroundColor White
Write-Host "  $InstallDir\Uninstall.bat" -ForegroundColor Gray
Write-Footer

if (-not $Silent) { Read-Host 'Enter 종료 / Press Enter to close' }
