#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 INPUT_VIDEO OUTPUT_VIDEO" >&2
  exit 2
fi

make run ARGS="$1 $2"
