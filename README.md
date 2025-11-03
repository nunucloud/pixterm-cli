# 🎨 Pixterm
**Pixterm**은 이미지를 **터미널용 ANSI/ASCII 아트**로 변환하는 파이썬 기반 유틸리티입니다.  
PNG, JPG, WEBP 등 어떤 이미지든 **터미널 안에서 컬러 픽셀처럼 시각화**할 수 있습니다.

---

## 💻 빠른 실행 예시

### 🐚 macOS / Linux
```bash
make demo
# 또는
python3 pixterm.py -i "./examples/hachuping.png" --ansi 
```

### 🪟 Windows
```powershell
pixterm.bat
# 또는
py .\pixterm.py -i .\examples\hachuping.png --ansi 
```

---

## 🌈 주요 특징

- 🖼️ **이미지 → ANSI/ASCII 변환**
  - 픽셀의 명암값을 문자로 변환하여 터미널에서 시각적으로 표현
- 🎨 **TrueColor(24-bit ANSI 컬러)** 완벽 지원
  - iTerm2, macOS Terminal, Windows Terminal 등 호환
- ⚙️ **간단한 CLI 인터페이스**
  - 직관적인 옵션 기반 제어
- 💫 **데모 모드 내장**
  - 이미지 없이 하트 모양 테스트 가능 (`--demo`)

---

## 🚀 설치 및 실행

### 1️⃣ 레포지토리 클론
```bash
git clone https://github.com/goorm-dev/pixterm.git
cd pixterm-cli
```

### 2️⃣ 의존성 설치
```bash
pip install -r requirements.txt
```

### 3️⃣ 이미지 → ASCII 출력
```bash
python3 pixterm.py -i "./examples/hachuping.webp" -w 160
```

### 4️⃣ 이미지 → 컬러 ANSI 출력
```bash
python3 pixterm.py -i "./examples/hachuping.webp" --ansi -w 160
```

### 5️⃣ 데모 하트 출력
```bash
python3 pixterm.py --demo -w 100
```

---

## ⚙️ 옵션 요약

| 옵션 | 설명 |
|------|------|
| `-i, --image` | 입력 이미지 경로 |
| `-w, --width` | 출력 가로 문자 수 (기본값: 120) |
| `--color` | 24-bit ANSI 컬러 출력 |
| `--ansi` | `--color`의 별칭 |
| `--invert` | 명암 반전 |
| `--charset` | 문자 세트 지정 (기본 `" .:-=+*#%@"`) |
| `--demo` | 하트 데모 출력 |

---

## 💡 활용 팁

### ✅ 컬러 출력 + 파일 저장 동시에
```bash
./pixterm.py -i "./examples/hachuping.webp" --ansi -w 160 | tee output.ansi
```

### ✅ 컬러가 깨질 때 (macOS/iTerm2 등)
```bash
export COLORTERM=truecolor
```

### ✅ ANSI 파일 미리보기
```bash
cat output.ansi
# 또는
less -R output.ansi
```

---

## 🖼️ 예시

예시 이미지: **하츄핑 (hachuping.webp)**  
> 이 이미지는 단순한 데모용 예시입니다.  
> Pixterm은 어떤 이미지에도 동일하게 적용 가능합니다.

```bash
python3 pixterm.py -i "./examples/hachuping.webp" --ansi -w 160
```

📸 *아래는 Pixterm으로 렌더링한 결과 예시입니다.*
(출력 예시 이미지 / GIF 첨부 권장)

---

## 📂 프로젝트 구조

```
pixterm-cli/
├── pixterm.py
├── requirements.txt
├── examples/
│   └── hachuping.webp
└── README.md
```

---

## 🧰 기술 스택

- **Python 3.10+**
- **Pillow** (이미지 처리)
- **ANSI 24-bit TrueColor**
- **CLI (argparse)**

---

## 🪄 예시 활용

Pixterm은 단순한 이미지 출력 도구가 아닙니다.  
- 터미널 배경화면 효과  
- SSH 아트 출력  
- CLI 앱 로딩 애니메이션  
- 콘솔 기반 시각화 프로젝트 등에도 활용할 수 있습니다.

---

## 📦 Repository Info

**Description:**  
> Convert any image into beautiful ANSI/ASCII art right in your terminal 🎨  
> 어떤 이미지든 터미널 안에서 컬러 ASCII 아트로 표현하세요.

**Topics:**  
`terminal-art, ascii-art, ansi-art, pixel-art, python3, cli-tool, image-to-ascii, terminal, visualization, unicode, color, truecolor`

---

## 📄 License
MIT License  
© 2025 Goorm / Nunu Kim  

🩵 *Bring your pixels to life — right inside your terminal.*
