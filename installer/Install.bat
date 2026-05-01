@echo off
setlocal
chcp 65001 > nul
title FLOW: AX디자인연구소 — ZoomIt 설치

echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║       FLOW: AX디자인연구소 — ZoomIt 화면 도구 설치           ║
echo  ║       v11.0 + 나눔바른펜 Bold 기본 설정                      ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.
echo   설치를 진행합니다. (관리자 권한 불필요)
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0scripts\install.ps1"

if errorlevel 1 (
    echo.
    echo   [오류] 설치가 실패했습니다.
    pause
    exit /b 1
)

endlocal
exit /b 0
