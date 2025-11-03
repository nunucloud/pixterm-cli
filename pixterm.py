#!/usr/bin/env python3
from __future__ import annotations
# -*- coding: utf-8 -*-

import sys
import os
import argparse

try:
    from PIL import Image
except Exception:
    Image = None

DEFAULT_SHADES = " .:-=+*#%@"
CHAR_ASPECT = 0.52


def to_gray(r: int, g: int, b: int) -> float:
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def map_to_char(v: float, shades: str, invert: bool) -> str:
    t = max(0.0, min(1.0, v / 255.0))
    if invert:
        t = 1.0 - t
    idx = int(t * (len(shades) - 1) + 0.5)
    return shades[idx]


def image_to_ascii(
    img_path: str,
    width: int = 120,
    shades: str = DEFAULT_SHADES,
    invert: bool = False,
    color: bool = False,
) -> str:
    if Image is None:
        raise RuntimeError("Pillow(PIL)가 설치되어 있지 않습니다.\n설치: pip install Pillow")

    if not os.path.exists(img_path):
        raise FileNotFoundError(f"이미지 파일을 찾을 수 없습니다: {img_path}")

    img = Image.open(img_path).convert("RGBA")

    try:
        bbox = img.getbbox()
        if bbox:
            img = img.crop(bbox)
    except Exception:
        pass

    w, h = img.size
    new_w = max(8, width)
    new_h = max(4, int(h * (new_w / w) * CHAR_ASPECT))
    img = img.resize((new_w, new_h), Image.LANCZOS)

    pixels = img.load()
    lines = []
    reset = "\x1b[0m" if color else ""
    for y in range(new_h):
        row_chars = []
        last_color = None
        for x in range(new_w):
            r, g, b, a = pixels[x, y]
            if a < 10:
                ch = " "
                if color and last_color is not None:
                    row_chars.append(reset)
                    last_color = None
                row_chars.append(ch)
                continue

            v = to_gray(r, g, b)
            ch = map_to_char(v, shades, invert)
            if color:
                esc = f"\x1b[38;2;{r};{g};{b}m"
                if esc != last_color:
                    if last_color is not None:
                        row_chars.append(reset)
                    row_chars.append(esc)
                    last_color = esc
                row_chars.append(ch)
            else:
                row_chars.append(ch)
        if color and last_color is not None:
            row_chars.append(reset)
        lines.append("".join(row_chars))
    return "\n".join(lines)


def demo_heart(width: int = 100, shades: str = DEFAULT_SHADES) -> str:
    out = []
    w = width
    h = int(width * 0.55)
    for j in range(h):
        v = j / max(h - 1, 1)
        line = []
        for i in range(w):
            u = i / max(w - 1, 1)
            x = (u * 2 - 1) * 1.2
            y = (v * 2 - 1) * 1.2
            a = x * x + y * y - 1
            f = a * a * a - x * x * (y * y * y)
            inside = f <= 0
            line.append(shades[-1] if inside else " ")
        out.append("".join(line))
    return "\n".join(out)


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description="이미지를 ASCII/ANSI 아트로 변환")
    p.add_argument("-i", "--image", dest="image")
    p.add_argument("-w", "--width", dest="width", type=int, default=120)
    p.add_argument("--color", action="store_true")
    p.add_argument("--ansi", action="store_true")
    p.add_argument("--charset", default=DEFAULT_SHADES)
    p.add_argument("--invert", action="store_true")
    p.add_argument("--demo", action="store_true")

    args = p.parse_args(argv)
    if getattr(args, "ansi", False):
        args.color = True

    try:
        if args.demo:
            print(demo_heart(args.width, args.charset))
            return 0
        if args.image:
            art = image_to_ascii(
                img_path=args.image,
                width=args.width,
                shades=args.charset,
                invert=args.invert,
                color=args.color,
            )
            print(art)
            return 0

        p.print_help()
        print("\n※ 예시: python3 pixterm.py -i ./image.png --ansi -w 160")
        return 2

    except Exception as e:
        sys.stderr.write(f"[ERROR] {e}\n")
        if Image is None:
            sys.stderr.write("\nPillow 설치 예시:\n  pip install Pillow\n")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())