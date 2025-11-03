param (
    [string]$Target = "help"
)

$VENV_DIR = ".venv"
$PYTHON = "py -3"
$REQ = "requirements.txt"
$EXAMPLE_IMG = "examples/hachuping.png"
$SCRIPT = if (Test-Path "pixterm.py") { "pixterm.py" } else { "heartsping.py" }

function Ensure-Venv {
    if (-not (Test-Path $VENV_DIR)) {
        & $PYTHON -m venv $VENV_DIR
        Write-Host "✅ Created venv at $VENV_DIR" -ForegroundColor Green
    }
}

function Activate {
    if (Test-Path "$VENV_DIR/Scripts/Activate.ps1") {
        & "$VENV_DIR/Scripts/Activate.ps1"
    } else {
        Write-Error "❌ Virtual environment not found. Run 'Make.ps1 install' first."
        exit 1
    }
}

switch ($Target.ToLower()) {

    "help" {
        Write-Host "pixterm-cli PowerShell targets:`n" -ForegroundColor Cyan
        Write-Host "  .\Make.ps1 install    - create venv and install requirements"
        Write-Host "  .\Make.ps1 run-ansi   - run with ANSI color using $EXAMPLE_IMG"
        Write-Host "  .\Make.ps1 run-ascii  - run in grayscale ASCII"
        Write-Host "  .\Make.ps1 demo       - run demo (Hachuping ANSI version)"
        Write-Host "  .\Make.ps1 clean      - remove venv"
    }

    "install" {
        Ensure-Venv
        & "$VENV_DIR/Scripts/python.exe" -m pip install --upgrade pip
        & "$VENV_DIR/Scripts/python.exe" -m pip install -r $REQ
        Write-Host "✅ Dependencies installed from $REQ" -ForegroundColor Green
    }

    "check" {
        Ensure-Venv
        & "$VENV_DIR/Scripts/python.exe" -c "import PIL; from PIL import Image; print('Pillow OK:', Image.__version__)"
        Write-Host "✅ Pillow import check passed" -ForegroundColor Green
    }

    "run-ansi" {
        if (-not (Test-Path $EXAMPLE_IMG)) {
            Write-Error "❌ Missing $EXAMPLE_IMG. Put your sample image there."
            exit 1
        }
        & "$VENV_DIR/Scripts/python.exe" $SCRIPT -i $EXAMPLE_IMG --ansi
    }

    "run-ascii" {
        if (-not (Test-Path $EXAMPLE_IMG)) {
            Write-Error "❌ Missing $EXAMPLE_IMG. Put your sample image there."
            exit 1
        }
        & "$VENV_DIR/Scripts/python.exe" $SCRIPT -i $EXAMPLE_IMG
    }

    "demo" {
        if (-not (Test-Path $EXAMPLE_IMG)) {
            Write-Error "❌ Missing $EXAMPLE_IMG. Put your sample image there."
            exit 1
        }
        Write-Host "💖 Showing Hachuping ANSI demo..." -ForegroundColor Magenta
        & "$VENV_DIR/Scripts/python.exe" $SCRIPT -i $EXAMPLE_IMG --ansi
    }

    "clean" {
        if (Test-Path $VENV_DIR) {
            Remove-Item -Recurse -Force $VENV_DIR
            Write-Host "🧹 Cleaned $VENV_DIR" -ForegroundColor Yellow
        } else {
            Write-Host "No venv to clean."
        }
    }

    default {
        Write-Error "❌ Unknown target: $Target"
    }
}