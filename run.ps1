param (
    [string]$Target = "help"
)

$VENV_DIR = Join-Path $PSScriptRoot ".venv"
$REQ = Join-Path $PSScriptRoot "requirements.txt"
$EXAMPLE_IMG = Join-Path $PSScriptRoot "examples/hachuping.png"
$SCRIPT = if (Test-Path (Join-Path $PSScriptRoot "pixterm.py")) { Join-Path $PSScriptRoot "pixterm.py" } else { Join-Path $PSScriptRoot "heartsping.py" }

function Ensure-Venv {
    if (-not (Test-Path $VENV_DIR)) {
        if ($IsWindows) {
            & py -3 -m venv $VENV_DIR
        } else {
            & python3 -m venv $VENV_DIR
        }
        Write-Host "✅ Created venv at $VENV_DIR" -ForegroundColor Green
    }
}

function Get-VenvPython {
    $pyWin = Join-Path $VENV_DIR "Scripts/python.exe"
    $pyNix = Join-Path $VENV_DIR "bin/python"
    if (Test-Path $pyWin) { return $pyWin }
    if (Test-Path $pyNix) { return $pyNix }
    Ensure-Venv
    if (Test-Path $pyWin) { return $pyWin }
    if (Test-Path $pyNix) { return $pyNix }
    throw "Python in venv not found at $pyWin or $pyNix"
}

function Ensure-Requirements {
    Ensure-Venv
    $py = Get-VenvPython
    try {
        & $py -c "import PIL, sys" *> $null
        if ($LASTEXITCODE -eq 0) { return }
    } catch { }
    & $py -m pip install --upgrade pip
    & $py -m pip install -r $REQ
    Write-Host "✅ Dependencies installed from $REQ" -ForegroundColor Green
}

switch ($Target.ToLower()) {

    "help" {
        Write-Host "pixterm-cli PowerShell targets:`n" -ForegroundColor Cyan
        Write-Host "  .\run.ps1 install   - create venv and install requirements"
        Write-Host "  .\run.ps1 run-ansi  - run with ANSI color using $EXAMPLE_IMG"
        Write-Host "  .\run.ps1 run-ascii - run in grayscale ASCII"
        Write-Host "  .\run.ps1 demo      - run demo (Hachuping ANSI version)"
        Write-Host "  .\run.ps1 clean     - remove venv"
        return
    }

    "install" {
        Ensure-Requirements
        return
    }

    "check" {
        Ensure-Venv
        $py = Get-VenvPython
        & $py -c "import PIL; from PIL import Image; print('Pillow OK:', Image.__version__)"
        Write-Host "✅ Pillow import check passed" -ForegroundColor Green
        return
    }

    "run-ansi" {
        Ensure-Requirements
        if (-not (Test-Path $EXAMPLE_IMG)) {
            Write-Error "❌ Missing $EXAMPLE_IMG. Put your sample image there."
            exit 1
        }
        $py = Get-VenvPython
        & $py $SCRIPT -i $EXAMPLE_IMG --ansi
        return
    }

    "run-ascii" {
        Ensure-Requirements
        if (-not (Test-Path $EXAMPLE_IMG)) {
            Write-Error "❌ Missing $EXAMPLE_IMG. Put your sample image there."
            exit 1
        }
        $py = Get-VenvPython
        & $py $SCRIPT -i $EXAMPLE_IMG
        return
    }

    "demo" {
        Ensure-Requirements
        if (-not (Test-Path $EXAMPLE_IMG)) {
            Write-Error "❌ Missing $EXAMPLE_IMG. Put your sample image there."
            exit 1
        }
        Write-Host "💖 Showing Hachuping ANSI demo..." -ForegroundColor Magenta
        $py = Get-VenvPython
        & $py $SCRIPT -i $EXAMPLE_IMG --ansi
        return
    }

    "clean" {
        if (Test-Path $VENV_DIR) {
            Remove-Item -Recurse -Force $VENV_DIR
            Write-Host "🧹 Cleaned $VENV_DIR" -ForegroundColor Yellow
        } else {
            Write-Host "No venv to clean."
        }
        return
    }

    default {
        Write-Error "❌ Unknown target: $Target"
        exit 1
    }
}