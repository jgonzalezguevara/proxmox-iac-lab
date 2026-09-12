#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUTPUT="${REPO_ROOT}/ansible/inventory/generated/rke2.ini"

mkdir -p "$(dirname "${OUTPUT}")"

"${REPO_ROOT}/ansible/scripts/generate-rke2-inventory.py" > "${OUTPUT}"

echo "Generated: ${OUTPUT}"
