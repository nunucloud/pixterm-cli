# ===============================
# Pixterm Windows Quick Runner
# Author : Nunu Kim
# ===============================

if ($PSVersionTable.PSVersion -lt [Version]"3.0") {
    Write-Error "PowerShell 3.0 이상이 필요합니다."
    exit 1
}

if ($MyInvocation.InvocationName -ne 'powershell') {
    Start-Process -FilePath 'powershell' -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ErrorActionPreference = 'Stop'

Write-Host "🎨 Pixterm 실행 준비 중..." -ForegroundColor Cyan

Write-Host "🚀 Pixterm 실행 중..." -ForegroundColor Green
cmd /c "py -3 pixterm.py -i ./examples/hachuping.png --ansi"

Write-Host "`n✅ 실행 완료!" -ForegroundColor Cyan
pause