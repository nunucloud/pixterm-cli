# Makefile for pixterm-cli
# usage:
#   make install        # venv 생성 + 의존성 설치
#   make run-ansi       # 예시 이미지로 터미널에 바로 ANSI 컬러 출력
#   make run-ascii      # 예시 이미지로 흑백 ASCII 출력
#   make demo           # 하츄핑 예시(ANSI) 출력
#   make clean          # venv 삭제

SHELL := /bin/bash
PYTHON ?= python3
VENV_DIR := .venv
VENV_BIN := $(VENV_DIR)/bin
ACTIVATE := source $(VENV_BIN)/activate
REQ := requirements.txt

# pixterm.py 가 있으면 사용, 없으면 heartsping.py 사용
SCRIPT := $(shell test -f pixterm.py && echo pixterm.py || echo heartsping.py)

EXAMPLE_IMG ?= examples/hachuping.png

.PHONY: help install venv check run-ansi run-ascii demo clean

help:
	@echo "pixterm-cli Make targets"
	@echo "  make install    - create venv and install requirements"
	@echo "  make run-ansi   - run with ANSI color using $(EXAMPLE_IMG)"
	@echo "  make run-ascii  - run in grayscale ASCII"
	@echo "  make demo       - run demo (Hachuping ANSI version)"
	@echo "  make clean      - remove venv"

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

run-ansi: install
	@test -f "$(EXAMPLE_IMG)" || (echo "❌ Missing $(EXAMPLE_IMG). Put your sample at $(EXAMPLE_IMG)" && exit 1)
	@$(ACTIVATE) && $(PYTHON) $(SCRIPT) -i "$(EXAMPLE_IMG)" --ansi 

run-ascii: install
	@test -f "$(EXAMPLE_IMG)" || (echo "❌ Missing $(EXAMPLE_IMG). Put your sample at $(EXAMPLE_IMG)" && exit 1)
	@$(ACTIVATE) && $(PYTHON) $(SCRIPT) -i "$(EXAMPLE_IMG)" 

demo: install
	@test -f "$(EXAMPLE_IMG)" || (echo "❌ Missing $(EXAMPLE_IMG). Put your sample at $(EXAMPLE_IMG)" && exit 1)
	@echo "💖 Showing Hachuping ANSI demo..."
	@$(ACTIVATE) && $(PYTHON) $(SCRIPT) -i "$(EXAMPLE_IMG)" --ansi 

clean:
	@rm -rf "$(VENV_DIR)"
	@echo "🧹 Cleaned .venv"