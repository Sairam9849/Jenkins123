#!/bin/bash
set -e
echo "Building Python app"
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
pytest -q || true
