@echo off
setlocal
chcp 65001 > nul
title FLOW: AX디자인연구소 — ZoomIt 제거

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0scripts\uninstall.ps1"

endlocal
exit /b 0
