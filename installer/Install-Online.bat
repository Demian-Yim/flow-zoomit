@echo off
setlocal
chcp 65001 > nul
title FLOW ZoomIt — Online Installer

echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║       FLOW ZoomIt — Online Installer / 온라인 설치           ║
echo  ║       Downloads ZoomIt v11.0 from Microsoft Sysinternals     ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.
echo   No admin rights needed. Internet connection required.
echo   관리자 권한 불필요. 인터넷 연결 필요.
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0install-online.ps1"

if errorlevel 1 (
    echo.
    echo   [Error] Installation failed.
    pause
    exit /b 1
)

endlocal
exit /b 0
