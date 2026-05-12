#!/usr/bin/env bash
# Toggle arbitrage background mode via a sentinel file.
# Usage: arbitrage-toggle.sh [on|off|status]
#
# The sentinel file is created/removed next to this script. A companion
# UserPromptSubmit hook should check for the sentinel and inject a QUICK
# reminder into the prompt when it is present.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTIVE_FILE="$SCRIPT_DIR/.active"

case "${1:-status}" in
  on)
    touch "$ACTIVE_FILE"
    echo "Arbitrage mode: ACTIVE"
    ;;
  off)
    rm -f "$ACTIVE_FILE"
    echo "Arbitrage mode: OFF"
    ;;
  status)
    if [ -f "$ACTIVE_FILE" ]; then
      echo "Arbitrage mode: ACTIVE"
    else
      echo "Arbitrage mode: OFF"
    fi
    ;;
  *)
    echo "Usage: arbitrage-toggle.sh [on|off|status]"
    exit 1
    ;;
esac
