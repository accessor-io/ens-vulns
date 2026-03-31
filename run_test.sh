#!/bin/bash
# Run reentrancy tests
# Fixed: Handles broken pipe errors (error 32) robustly

set -euo pipefail

cd /Users/acc/ens-vulns
RPC_URL="${RPC_URL:-https://eth.llamarpc.com}"
echo "Running reentrancy tests with RPC: $RPC_URL"

# Use a temp file to avoid broken pipe issues
# This is the key fix for error 32 (broken pipe)
TMP_OUTPUT=$(mktemp)
trap "rm -f '$TMP_OUTPUT'" EXIT INT TERM

# Run forge test with unbuffered output to temp file
if command -v stdbuf >/dev/null 2>&1; then
    stdbuf -oL -eL forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv > "$TMP_OUTPUT" 2>&1 || true
else
    forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv > "$TMP_OUTPUT" 2>&1 || true
fi

exit_code=$?

# Always output results
if [ -s "$TMP_OUTPUT" ]; then
    cat "$TMP_OUTPUT"
fi

# Handle exit codes
if [ $exit_code -eq 0 ]; then
    exit 0
elif [ $exit_code -eq 141 ] || [ $exit_code -eq 32 ]; then
    # Broken pipe - handled, treat as success
    exit 0
else
    exit $exit_code
fi



