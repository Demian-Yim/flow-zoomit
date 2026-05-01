#requires -Version 5.1
<#
.SYNOPSIS
  FLOW: AX디자인연구소 — ZoomIt v11.0 + 나눔바른펜 Bold 기본 설정 설치 스크립트
.DESCRIPTION
  - ZoomIt64.exe (v11.0)을 %LOCALAPPDATA%\FLOW-ZoomIt\ 에 복사
  - 단축키 (Ctrl+1~4) 등록
  - 기본 폰트를 나눔바른펜 Bold로 설정 (LOGFONT 바이너리 작성)
  - 시작 메뉴 / 바탕화면 / 시작프로그램 바로가기 생성
  - 트레이 자동 실행
.NOTES
  관리자 권한 불필요 (사용자 영역에 설치)
#>

[CmdletBinding()]
param(
    [switch]$Silent,
    [switch]$NoStartup
)

$ErrorActionPreference = 'Stop'

# ─────────────────────────────────────────────────────────────────────────────
# 0. 풋터·헤더 출력
# ─────────────────────────────────────────────────────────────────────────────
function Write-Banner {
    $line = '═' * 64
    Write-Host ''
    Write-Host $line -ForegroundColor Cyan
    Write-Host '   FLOW: AX디자인연구소 — ZoomIt 설치 도우미' -ForegroundColor White
    Write-Host '   ZoomIt v11.0 + 나눔바른펜 Bold 기본 설정' -ForegroundColor Gray
    Write-Host $line -ForegroundColor Cyan
    Write-Host ''
}

function Write-Footer {
    $line = '─' * 64
    Write-Host ''
    Write-Host $line -ForegroundColor DarkGray
    Write-Host '   FLOW: AX디자인연구소' -ForegroundColor White
    Write-Host '   by AI 코디네이터 임정훈 소장' -ForegroundColor Gray
    Write-Host '   🌐 https://flowdesign.ai.kr' -ForegroundColor Cyan
    Write-Host '   © 2026 FLOW: AX디자인연구소 All Rights Reserved.' -ForegroundColor DarkGray
    Write-Host $line -ForegroundColor DarkGray
    Write-Host ''
}

Write-Banner

# ─────────────────────────────────────────────────────────────────────────────
# 1. 경로 정의
# ─────────────────────────────────────────────────────────────────────────────
$AppName    = 'FLOW-ZoomIt'
$InstallDir = Join-Path $env:LOCALAPPDATA $AppName
$ExeName    = 'ZoomIt64.exe'
$ExePath    = Join-Path $InstallDir $ExeName

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ZoomIt64.exe 위치 자동 탐지 (폴더형 / IExpress 평면형 / 동일 폴더)
$candidatePaths = @(
    Join-Path (Split-Path -Parent $ScriptDir) "payload\$ExeName"  # FLOW-ZoomIt-Setup/payload/
    Join-Path $ScriptDir $ExeName                                  # IExpress 평면 구조
    Join-Path (Split-Path -Parent $ScriptDir) $ExeName             # 같은 부모 폴더
)
$SourceExe = $candidatePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $SourceExe) {
    Write-Host '[오류] ZoomIt64.exe 를 찾을 수 없습니다. 설치 패키지가 손상되었습니다.' -ForegroundColor Red
    Write-Host '  탐색 경로:' -ForegroundColor DarkGray
    $candidatePaths | ForEach-Object { Write-Host "    - $_" -ForegroundColor DarkGray }
    Write-Footer
    if (-not $Silent) { Read-Host '엔터를 누르면 종료됩니다' }
    exit 1
}

# about.html 위치 자동 탐지 (있으면 설치, 없으면 스킵)
$aboutCandidates = @(
    Join-Path (Split-Path -Parent $ScriptDir) 'payload\about.html'
    Join-Path $ScriptDir 'about.html'
    Join-Path (Split-Path -Parent $ScriptDir) 'about.html'
)
$SourceAbout = $aboutCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

# ─────────────────────────────────────────────────────────────────────────────
# 2. 기존 ZoomIt 종료
# ─────────────────────────────────────────────────────────────────────────────
Write-Host '[1/6] 실행 중인 ZoomIt 종료...' -ForegroundColor Yellow
Get-Process -Name 'ZoomIt*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
Write-Host '      완료' -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────────────
# 3. 파일 복사
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "[2/6] 파일 복사: $InstallDir" -ForegroundColor Yellow
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}
Copy-Item -Path $SourceExe -Destination $ExePath -Force

# about.html 도 같은 폴더에 함께 배치 (시작 메뉴 「정보」 바로가기에서 참조)
$AboutDest = Join-Path $InstallDir 'about.html'
if ($SourceAbout) {
    Copy-Item -Path $SourceAbout -Destination $AboutDest -Force
}
Write-Host '      완료' -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────────────
# 4. EULA + 단축키 + 트레이 + 폰트 레지스트리 작성
# ─────────────────────────────────────────────────────────────────────────────
Write-Host '[3/6] 레지스트리 설정 (EULA · 단축키 · 트레이) ...' -ForegroundColor Yellow

$RegPath = 'HKCU:\Software\Sysinternals\ZoomIt'
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# EULA 자동 수락 (사용자가 첫 실행 시 다이얼로그 안 뜨게)
Set-ItemProperty -Path $RegPath -Name 'EulaAccepted' -Value 1 -Type DWord
Set-ItemProperty -Path $RegPath -Name 'OptionsShown' -Value 1 -Type DWord

# ZoomIt 설치 경로
Set-ItemProperty -Path $RegPath -Name 'FilePath' -Value "`"$ExePath`"" -Type String

# 기본 단축키 (현 환경 그대로 유지)
Set-ItemProperty -Path $RegPath -Name 'ToggleKey'         -Value 0x231 -Type DWord  # Ctrl+1
Set-ItemProperty -Path $RegPath -Name 'DrawToggleKey'     -Value 0x232 -Type DWord  # Ctrl+2
Set-ItemProperty -Path $RegPath -Name 'BreakTimerKey'     -Value 0x233 -Type DWord  # Ctrl+3
Set-ItemProperty -Path $RegPath -Name 'LiveZoomToggleKey' -Value 0x234 -Type DWord  # Ctrl+4

# 트레이 아이콘 표시
Set-ItemProperty -Path $RegPath -Name 'ShowTrayIcon'      -Value 1 -Type DWord

# 폰트 크기 스케일 (현재값 유지)
if (-not (Get-ItemProperty -Path $RegPath -Name 'FontScale' -ErrorAction SilentlyContinue)) {
    Set-ItemProperty -Path $RegPath -Name 'FontScale' -Value 30 -Type DWord
}

# 펜 색상·두께 (FLOW 기본값: 화살표 헤드 좌우폭 충분히 보이도록 PenWidth 15)
if (-not (Get-ItemProperty -Path $RegPath -Name 'PenColor' -ErrorAction SilentlyContinue)) {
    Set-ItemProperty -Path $RegPath -Name 'PenColor' -Value 0xFF -Type DWord  # Red
}
# PenWidth는 신규/기존 무관하게 FLOW 기본값(15)으로 설정
Set-ItemProperty -Path $RegPath -Name 'PenWidth' -Value 15 -Type DWord

Write-Host '      완료' -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────────────
# 5. 폰트 레지스트리: 나눔바른펜 Bold (LOGFONTW 바이너리)
# ─────────────────────────────────────────────────────────────────────────────
Write-Host '[4/6] 기본 폰트 설정: 나눔바른펜 Bold ...' -ForegroundColor Yellow

# LOGFONTW 구조체 (92바이트):
#   lfHeight (4) | lfWidth (4) | lfEscapement (4) | lfOrientation (4)
#   lfWeight (4) | lfItalic (1) | lfUnderline (1) | lfStrikeOut (1) | lfCharSet (1)
#   lfOutPrecision (1) | lfClipPrecision (1) | lfQuality (1) | lfPitchAndFamily (1)
#   lfFaceName (64 = 32 WCHAR)
#
# 우리 설정: 굵기 700 (Bold), 한국어 차셋, 안티앨리어스, 페이스 = "나눔바른펜"
# (face name "나눔바른펜 Bold"도 가능하지만, lfWeight=700 이면 GDI가 굵은 변형을 자동 선택)

$logfont = New-Object byte[] 92

function Write-Int32LE {
    param($buf, $offset, [int]$value)
    [System.BitConverter]::GetBytes($value) | ForEach-Object -Begin { $i = 0 } -Process {
        $buf[$offset + $i] = $_
        $i++
    }
}

Write-Int32LE $logfont 0  -41          # lfHeight (-41 = 약 30pt 캐릭터 높이)
Write-Int32LE $logfont 4   0           # lfWidth
Write-Int32LE $logfont 8   0           # lfEscapement
Write-Int32LE $logfont 12  0           # lfOrientation
Write-Int32LE $logfont 16  700         # lfWeight = FW_BOLD
$logfont[20] = 0                        # lfItalic
$logfont[21] = 0                        # lfUnderline
$logfont[22] = 0                        # lfStrikeOut
$logfont[23] = 129                      # lfCharSet = HANGEUL_CHARSET (0x81)
$logfont[24] = 0                        # lfOutPrecision = OUT_DEFAULT_PRECIS
$logfont[25] = 0                        # lfClipPrecision = CLIP_DEFAULT_PRECIS
$logfont[26] = 4                        # lfQuality = ANTIALIASED_QUALITY
$logfont[27] = 0                        # lfPitchAndFamily = DEFAULT_PITCH | FF_DONTCARE

# lfFaceName: UTF-16 LE, "나눔바른펜" + null terminator
$faceName = '나눔바른펜'
$faceBytes = [System.Text.Encoding]::Unicode.GetBytes($faceName)
[Array]::Copy($faceBytes, 0, $logfont, 28, $faceBytes.Length)
# 나머지는 0 (이미 0으로 초기화됨)

Set-ItemProperty -Path $RegPath -Name 'Font' -Value $logfont -Type Binary
Write-Host '      완료 (변경 안 되면 트레이 우클릭 → Options → Font 에서 수동 선택)' -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────────────
# 6. 시작 메뉴 + 바탕화면 + 시작프로그램 바로가기
# ─────────────────────────────────────────────────────────────────────────────
Write-Host '[5/6] 바로가기 생성 ...' -ForegroundColor Yellow

$WshShell = New-Object -ComObject WScript.Shell

function New-Shortcut {
    param([string]$Path, [string]$Target, [string]$Description)
    if (Test-Path $Path) { Remove-Item $Path -Force }
    $sc = $WshShell.CreateShortcut($Path)
    $sc.TargetPath  = $Target
    $sc.Description = $Description
    $sc.WorkingDirectory = Split-Path -Parent $Target
    $sc.Save()
}

# 시작 메뉴
$StartMenuDir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\FLOW-ZoomIt'
if (-not (Test-Path $StartMenuDir)) {
    New-Item -ItemType Directory -Path $StartMenuDir -Force | Out-Null
}
New-Shortcut `
    -Path        (Join-Path $StartMenuDir 'FLOW ZoomIt.lnk') `
    -Target      $ExePath `
    -Description 'FLOW: AX디자인연구소 — ZoomIt 화면 도구'

# 시작 메뉴: 정보 / 도움말 (about.html → 기본 브라우저)
if (Test-Path $AboutDest) {
    New-Shortcut `
        -Path        (Join-Path $StartMenuDir 'FLOW ZoomIt 정보.lnk') `
        -Target      $AboutDest `
        -Description '제작 배경·단축키·라이선스·푸터'
}

# 바탕화면
$DesktopShortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) 'FLOW ZoomIt.lnk'
New-Shortcut `
    -Path        $DesktopShortcut `
    -Target      $ExePath `
    -Description 'FLOW: AX디자인연구소 — ZoomIt 화면 도구'

# 시작프로그램 (Windows 부팅 시 자동 실행)
if (-not $NoStartup) {
    $StartupDir = [Environment]::GetFolderPath('Startup')
    New-Shortcut `
        -Path        (Join-Path $StartupDir 'FLOW ZoomIt.lnk') `
        -Target      $ExePath `
        -Description 'FLOW ZoomIt 자동 실행'
}

Write-Host '      완료' -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────────────
# 7. 즉시 실행
# ─────────────────────────────────────────────────────────────────────────────
Write-Host '[6/6] ZoomIt 트레이 실행 ...' -ForegroundColor Yellow
Start-Process -FilePath $ExePath
Start-Sleep -Milliseconds 800
Write-Host '      완료 — 시스템 트레이에 ZoomIt 아이콘이 떴습니다.' -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────────────
# 8. 안내
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '━━━ 설치 완료 ━━━' -ForegroundColor Green
Write-Host ''
Write-Host '단축키:' -ForegroundColor White
Write-Host '  Ctrl+1   정적 줌 (마우스휠로 배율 · ESC 종료)' -ForegroundColor Gray
Write-Host '  Ctrl+2   그리기 모드 (T로 텍스트 · ESC 종료)' -ForegroundColor Gray
Write-Host '  Ctrl+3   휴식 타이머' -ForegroundColor Gray
Write-Host '  Ctrl+4   라이브 줌 (실시간 화면 확대)' -ForegroundColor Gray
Write-Host ''
Write-Host '한글 입력:' -ForegroundColor White
Write-Host '  Ctrl+2 → T → 캔버스 클릭 → 한/영 키 → 한글 입력' -ForegroundColor Gray
Write-Host ''
Write-Host '폰트 변경:' -ForegroundColor White
Write-Host '  트레이 아이콘 우클릭 → Options... → Type 탭 → Font' -ForegroundColor Gray
Write-Host ''
Write-Host '정보 / 도움말:' -ForegroundColor White
Write-Host '  시작 메뉴 → FLOW-ZoomIt → "FLOW ZoomIt 정보"' -ForegroundColor Gray
Write-Host '  (제작 배경·단축키·라이선스·푸터)' -ForegroundColor DarkGray
Write-Host ''
Write-Host '제거:' -ForegroundColor White
Write-Host "  $InstallDir 폴더의 Uninstall.bat 실행" -ForegroundColor Gray
Write-Host ''

# 제거 스크립트도 InstallDir에 복사 (사용자가 쉽게 실행 가능하게)
$UninstallSrc = Join-Path $ScriptDir 'uninstall.ps1'
$UninstallDst = Join-Path $InstallDir 'uninstall.ps1'
if (Test-Path $UninstallSrc) {
    Copy-Item -Path $UninstallSrc -Destination $UninstallDst -Force
}

# Uninstall.bat 도 함께 생성
$UninstallBat = @'
@echo off
chcp 65001 > nul
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0uninstall.ps1"
pause
'@
Set-Content -Path (Join-Path $InstallDir 'Uninstall.bat') -Value $UninstallBat -Encoding UTF8

Write-Footer

if (-not $Silent) {
    Read-Host '엔터를 누르면 창을 닫습니다'
}
