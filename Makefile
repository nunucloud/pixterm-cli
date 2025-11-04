SHELL := /bin/bash
PYTHON ?= python3
VENV_DIR := .venv
VENV_BIN := $(VENV_DIR)/bin
ACTIVATE := source $(VENV_BIN)/activate
REQ := requirements.txt

SCRIPT := $(shell test -f pixterm.py && echo pixterm.py || echo heartsping.py)

EXAMPLE_IMG ?= examples/hachuping.png

RAW_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
IMG_CAND := $(firstword $(filter-out %=%,$(RAW_ARGS)))
IMG := $(if $(IMG_CAND),$(IMG_CAND),$(EXAMPLE_IMG))

WIDTH := $(if $(w),$(w),120)

%:
	@:

.PHONY: help install venv check run run-ascii demo clean

help:
	@echo "pixterm-cli Make targets"
	@echo "  make install                      - create venv and install requirements"
	@echo "  make run [FILE] [w=WIDTH]         - ANSI color output (default FILE: $(EXAMPLE_IMG), default WIDTH: $(WIDTH))"
	@echo "  make run-ascii [FILE] [w=WIDTH]    - grayscale ASCII output"
	@echo "  make demo [w=WIDTH]               - Hachuping ANSI demo"
	@echo "  make clean                        - remove venv"
	@echo "\n예시:"
	@echo "  make run                          # 기본 예시 이미지 ANSI 출력"
	@echo "  make run examples/cat.png w=160   # 파일 지정 + 가로폭 지정"
	@echo "  make run-ascii w=100              # 흑백 ASCII, 폭 100"

$(VENV_DIR):
	@$(PYTHON) -m venv $(VENV_DIR)
	@echo "✅ Created venv at $(VENV_DIR)"

venv: $(VENV_DIR)

install: venv
	@$(ACTIVATE) && pip install --upgrade pip
	@$(ACTIVATE) && pip install -r $(REQ)
	@echo "✅ Dependencies installed from $(REQ)"

check: venv
	@$(ACTIVATE) && $(PYTHON) -c "import PIL; from PIL import Image; print('Pillow OK:', Image.__version__)"
	@echo "✅ Pillow import check passed"

run: install
	@test -f "$(IMG)" || (echo "❌ Missing $(IMG). Put your sample at $(IMG)" && exit 1)
	@$(ACTIVATE) && $(PYTHON) $(SCRIPT) -i "$(IMG)" --ansi -w $(WIDTH)

run-ascii: install
	@test -f "$(IMG)" || (echo "❌ Missing $(IMG). Put your sample at $(IMG)" && exit 1)
	@$(ACTIVATE) && $(PYTHON) $(SCRIPT) -i "$(IMG)" -w $(WIDTH)

demo: install
	@test -f "$(IMG)" || (echo "❌ Missing $(IMG). Put your sample at $(IMG)" && exit 1)
	@echo "💖 Showing Hachuping ANSI demo..."
	@$(ACTIVATE) && $(PYTHON) $(SCRIPT) -i "$(IMG)" --ansi -w $(WIDTH)

clean:
	@rm -rf "$(VENV_DIR)"
	@echo "🧹 Cleaned .venv"