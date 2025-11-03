# ===============================
# Pixterm Windows Quick Runner
# Author : Nunu Kim
# ===============================

$ErrorActionPreference = 'Stop'

Write-Host "🎨 Pixterm 실행 준비 중..." -ForegroundColor Cyan

Write-Host "🚀 Pixterm 실행 중..." -ForegroundColor Green
cmd /c "py -3 pixterm.py -i ./examples/hachuping.png --ansi"

# 5. 정리 (선택: 주석 해제 시 자동 삭제)
# Remove-Item $bat -Force

Write-Host "`n✅ 실행 완료! (임시 파일: $bat)" -ForegroundColor Cyan
pause