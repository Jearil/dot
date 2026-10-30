"""
c64lib.py — Shared library for C64 Ultimate remote interaction scripts.

Provides:
  - Config management (~/.c64/config)
  - argparse base parser with --ip
  - PETSCII escape sequence conversion
  - Screen code → display character mapping
  - C64 API client class
"""

import argparse
import json
import re
import sys
import time
from ftplib import FTP, error_perm
from io import BytesIO
from pathlib import Path

import requests

# ── Config ────────────────────────────────────────────────────────────────────

CONFIG_FILE = Path.home() / '.c64' / 'config'


def load_config(ip_override=None) -> str:
    """Return IP address to use.

    Rules:
      - If ip_override given AND no config → create config, print message, return ip
      - If ip_override given AND config with different IP → update config, print message
      - If ip_override given AND config with same IP → return ip (no message)
      - If no ip_override AND config exists → return stored IP
      - If no ip_override AND config missing → error with helpful message
    """
    existing = None
    if CONFIG_FILE.exists():
        try:
            existing = json.loads(CONFIG_FILE.read_text())['ip']
        except Exception:
            existing = None

    if ip_override:
        if existing is None:
            save_config(ip_override)
            print(f"Config created: {CONFIG_FILE} (ip={ip_override})")
        elif existing != ip_override:
            save_config(ip_override)
            print(f"Config updated: {CONFIG_FILE} (ip={existing} → {ip_override})")
        return ip_override

    if existing is not None:
        return existing

    print(
        "Error: no C64 IP configured.\n"
        "Run with --ip <address> to set it, e.g.:\n"
        "  c64_read_screen --ip 192.168.1.46",
        file=sys.stderr,
    )
    sys.exit(1)


def save_config(ip: str):
    """Write IP to ~/.c64/config as JSON."""
    CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
    CONFIG_FILE.write_text(json.dumps({'ip': ip}, indent=2) + '\n')


# ── argparse helper ───────────────────────────────────────────────────────────


def base_parser(description) -> argparse.ArgumentParser:
    """Return an ArgumentParser pre-loaded with a --ip argument."""
    p = argparse.ArgumentParser(description=description)
    p.add_argument('--ip', metavar='ADDRESS', help='C64 Ultimate IP (saved to ~/.c64/config)')
    return p


# ── PETSCII escape sequences ──────────────────────────────────────────────────

PETSCII_ESCAPES = {
    # Navigation / editing
    'RETURN':       0x0D,
    'RET':          0x0D,
    'SHIFT-RETURN': 0x8D,
    'HOME':         0x13,
    'CLR':          0x93,
    'CLEAR':        0x93,
    'UP':           0x91,
    'DOWN':         0x11,
    'LEFT':         0x9D,
    'RIGHT':        0x1D,
    'DEL':          0x14,
    'DELETE':       0x14,
    'INSERT':       0x94,
    'INS':          0x94,
    'TAB':          0x09,
    'RUN/STOP':     0x03,
    'STOP':         0x03,
    # Function keys
    'F1': 0x85, 'F2': 0x86, 'F3': 0x87, 'F4': 0x88,
    'F5': 0x89, 'F6': 0x8A, 'F7': 0x8B, 'F8': 0x8C,
    # Text mode
    'REVERSE ON':  0x12,
    'REVERSE OFF': 0x92,
    'LOWERCASE':   0x0E,
    'UPPERCASE':   0x8E,
    # Colors
    'BLACK':       0x90,
    'WHITE':       0x05,
    'RED':         0x1C,
    'CYAN':        0x9F,
    'PURPLE':      0x9C,
    'GREEN':       0x1E,
    'BLUE':        0x1F,
    'YELLOW':      0x9E,
    'ORANGE':      0x81,
    'BROWN':       0x95,
    'LIGHT RED':   0x96,
    'DARK GRAY':   0x97,
    'GRAY':        0x98,
    'MEDIUM GRAY': 0x98,
    'LIGHT GREEN': 0x99,
    'LIGHT BLUE':  0x9A,
    'LIGHT GRAY':  0x9B,
}

_ESCAPE_RE = re.compile(r'\{([^}]+)\}')


def text_to_petscii(text: str) -> bytes:
    """Convert a string (with optional {KEY} escapes) to PETSCII bytes.

    - Printable ASCII 32-95 maps directly (uppercase PETSCII mode)
    - Lowercase a-z is uppercased automatically
    - {KEY_NAME} sequences → PETSCII control bytes
    - Raises ValueError on unknown {KEY} names
    """
    result = bytearray()
    pos = 0
    for m in _ESCAPE_RE.finditer(text):
        # Handle literal text before this escape
        chunk = text[pos:m.start()]
        result.extend(_ascii_to_petscii(chunk))
        pos = m.end()

        key = m.group(1).upper()
        if key not in PETSCII_ESCAPES:
            raise ValueError(f"Unknown PETSCII escape: {{{m.group(1)}}}")
        result.append(PETSCII_ESCAPES[key])

    # Remaining text after last escape
    result.extend(_ascii_to_petscii(text[pos:]))
    return bytes(result)


def _ascii_to_petscii(text: str) -> bytes:
    """Convert plain text to PETSCII bytes (uppercase, no escape processing)."""
    result = bytearray()
    for ch in text:
        if 'a' <= ch <= 'z':
            result.append(ord(ch) - 32)   # uppercase
        elif 32 <= ord(ch) <= 95:
            result.append(ord(ch))
        else:
            # Skip or substitute characters outside mappable range
            pass
    return bytes(result)


# ── Screen code → display character ──────────────────────────────────────────

# CBM graphics characters mapped to Unicode box-drawing / block elements
# Indices 0-31 correspond to screen codes 64-95 (and 96-127)
_CBM_GRAPHICS = [
    '─', '▌', '─', '─', '▄', '▔', '░', '▒',   # 64-71
    '▓', '┼', '╮', '├', '└', '┐', '╮', '▗',   # 72-79
    '▘', '▀', '▙', '▚', '▛', '▜', '▟', '▝',   # 80-87
    '▃', '▎', '▍', '▋', '▊', '▉', '█', '▉',   # 88-95
]


def sc_to_char(code: int) -> str:
    """Convert a C64 screen code byte to a display character."""
    code &= 0x7F   # strip reverse-video bit
    if code == 0:
        return '@'
    if 1 <= code <= 26:
        return chr(64 + code)   # A-Z
    if code == 27:
        return '['
    if code == 28:
        return '£'
    if code == 29:
        return ']'
    if code == 30:
        return '↑'
    if code == 31:
        return '←'
    if 32 <= code <= 63:
        return chr(code)   # space, digits, punctuation
    if 64 <= code <= 95:
        return _CBM_GRAPHICS[code - 64]
    if 96 <= code <= 127:
        return _CBM_GRAPHICS[code - 96]
    return '.'


# ── C64 API Client ────────────────────────────────────────────────────────────


class C64:
    SCREEN_RAM = 0x0400
    KB_BUF     = 0x0277
    KB_COUNT   = 0x00C6

    def __init__(self, ip: str):
        self.base = f'http://{ip}'
        self.ip = ip

    # ── Low-level API ─────────────────────────────────────────────────────────

    def reset(self):
        """Reset the C64 via PUT /v1/machine:reset. Raises on error."""
        r = requests.put(f'{self.base}/v1/machine:reset', timeout=5)
        r.raise_for_status()
        resp = r.json()
        if resp.get('errors'):
            raise RuntimeError(f'reset error: {resp["errors"]}')

    def alive(self, timeout=3) -> bool:
        """Return True if the HTTP API is responding."""
        try:
            requests.get(f'{self.base}/v1/version', timeout=timeout)
            return True
        except Exception:
            return False

    def readmem(self, addr: int, length: int) -> bytes:
        """Read memory via GET /v1/machine:readmem. Returns raw bytes."""
        r = requests.get(
            f'{self.base}/v1/machine:readmem',
            params={'address': f'{addr:04X}', 'length': length},
            timeout=5,
        )
        r.raise_for_status()
        return r.content

    def writemem(self, addr: int, data: bytes):
        """Write memory via PUT /v1/machine:writemem. Max 128 bytes. Raises on error."""
        if len(data) > 128:
            raise ValueError(f'writemem: data too long ({len(data)} bytes, max 128)')
        r = requests.put(
            f'{self.base}/v1/machine:writemem',
            params={'address': f'{addr:04X}', 'data': data.hex()},
            timeout=5,
        )
        r.raise_for_status()
        resp = r.json()
        if resp.get('errors'):
            raise RuntimeError(f'writemem error: {resp["errors"]}')

    # ── Screen ────────────────────────────────────────────────────────────────

    def read_screen(self) -> list:
        """Read all 25 rows from screen RAM. Returns list of 40-char decoded strings."""
        rows = []
        for row in range(25):
            addr = self.SCREEN_RAM + row * 40
            data = self.readmem(addr, 40)
            rows.append(''.join(sc_to_char(b) for b in data))
        return rows

    # ── Keyboard buffer ───────────────────────────────────────────────────────

    def _drain_keyboard(self, timeout=5.0):
        """Poll $C6 until the keyboard buffer is empty (count == 0)."""
        deadline = time.time() + timeout
        while time.time() < deadline:
            count = self.readmem(self.KB_COUNT, 1)
            if count[0] == 0:
                return
            time.sleep(0.05)

    def send_petscii(self, data: bytes):
        """Send arbitrary PETSCII bytes through the keyboard buffer.

        Splits into ≤9-byte chunks. Drains buffer between each chunk.
        Handles inputs longer than 10 bytes transparently.
        """
        for i in range(0, len(data), 9):
            chunk = data[i:i + 9]
            self._drain_keyboard(timeout=5.0)
            self.writemem(self.KB_BUF, chunk)
            self.writemem(self.KB_COUNT, bytes([len(chunk)]))
            time.sleep(0.02)

    def send_text(self, text: str, append_return=True):
        """Convert text (with {KEY} escapes) to PETSCII and send via keyboard buffer."""
        data = text_to_petscii(text)
        if append_return:
            data += bytes([0x0D])
        self.send_petscii(data)

    # ── Program runners ───────────────────────────────────────────────────────

    def load_prg(self, data: bytes) -> dict:
        """POST /v1/runners:load_prg — DMA load without execution."""
        r = requests.post(
            f'{self.base}/v1/runners:load_prg',
            data=data,
            headers={'Content-Type': 'application/octet-stream'},
            timeout=10,
        )
        r.raise_for_status()
        return r.json()

    def run_prg(self, data: bytes) -> dict:
        """POST /v1/runners:run_prg — DMA load and execute."""
        r = requests.post(
            f'{self.base}/v1/runners:run_prg',
            data=data,
            headers={'Content-Type': 'application/octet-stream'},
            timeout=10,
        )
        r.raise_for_status()
        return r.json()

    # ── FTP upload ────────────────────────────────────────────────────────────

    def ftp_upload(self, data: bytes, remote_path: str):
        """Upload bytes to remote_path on the C64 Ultimate filesystem via FTP.

        Uses anonymous FTP (port 21). Creates missing directories.
        Raises on failure.
        """
        remote = Path(remote_path)
        remote_dir = str(remote.parent)
        remote_name = remote.name

        ftp = FTP()
        ftp.connect(self.ip, 21, timeout=10)
        ftp.login()   # anonymous

        # Navigate to (or create) the target directory
        parts = [p for p in remote_dir.split('/') if p]
        ftp.cwd('/')
        for part in parts:
            try:
                ftp.cwd(part)
            except error_perm:
                ftp.mkd(part)
                ftp.cwd(part)

        ftp.storbinary(f'STOR {remote_name}', BytesIO(data))
        ftp.quit()

    def ftp_connect(self) -> FTP:
        """Open an anonymous FTP connection and return the handle."""
        ftp = FTP()
        ftp.connect(self.ip, 21, timeout=10)
        ftp.login()
        return ftp

    def ftp_listdir(self, ftp: FTP, path: str) -> list:
        """Return bare filenames in path via NLST, or [] if path doesn't exist."""
        try:
            return [Path(entry).name for entry in ftp.nlst(path)]
        except Exception:
            return []

    def ftp_ensure_dir(self, ftp: FTP, path: str):
        """Create path via MKD; silently ignore error if it already exists."""
        try:
            ftp.mkd(path)
        except error_perm:
            pass
