#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -f ".env" ]]; then
  echo "x-reader: missing .env. Copy env.example to .env and set X_BEARER_TOKEN before starting the MCP server." >&2
  exit 1
fi

VENV="${XMCP_VENV:-.venv}"

python_ok() {
  "$1" - <<'PY'
import sys
raise SystemExit(0 if sys.version_info >= (3, 10) else 1)
PY
}

find_python() {
  if [[ -n "${XMCP_PYTHON:-}" ]]; then
    printf '%s\n' "$XMCP_PYTHON"
    return 0
  fi

  for candidate in python3.12 python3.11 python3.10 python3; do
    if command -v "$candidate" >/dev/null 2>&1 && python_ok "$candidate"; then
      command -v "$candidate"
      return 0
    fi
  done

  return 1
}

if [[ ! -x "$VENV/bin/python" ]]; then
  if command -v uv >/dev/null 2>&1; then
    uv venv --python 3.12 "$VENV" >&2
  else
    PYTHON="$(find_python || true)"
    if [[ -z "$PYTHON" ]]; then
      echo "x-reader: Python 3.10+ is required. Install Python 3.12 or uv, or set XMCP_PYTHON." >&2
      exit 1
    fi
    "$PYTHON" -m venv "$VENV"
  fi
fi

if [[ ! -f "$VENV/.xmcp-deps-installed" || "requirements.txt" -nt "$VENV/.xmcp-deps-installed" ]]; then
  "$VENV/bin/python" -m pip --disable-pip-version-check install -q -r requirements.txt >&2
  touch "$VENV/.xmcp-deps-installed"
fi

exec "$VENV/bin/python" server.py
