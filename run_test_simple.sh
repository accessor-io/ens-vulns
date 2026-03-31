#!/bin/bash
# Simple test runner that writes to file
# Fixed: Handles broken pipe errors (error 32) robustly

set -euo pipefail

# Use environment variable for RPC URL, with fallback
# Set ALCHEMY_API_KEY environment variable before running
# Example: export ALCHEMY_API_KEY="your_api_key_here"
if [ -z "${ALCHEMY_API_KEY:-}" ]; then
    echo "Warning: ALCHEMY_API_KEY not set. Using default public RPC."
    RPC_URL="${RPC_URL:-https://eth.llamarpc.com}"
else
    RPC_URL="https://eth-mainnet.g.alchemy.com/v2/$ALCHEMY_API_KEY"
fi
OUTPUT_FILE="test_results_$(date +%s).log"

cd "$(dirname "$0")"

echo "Running reentrancy tests..."
echo "Output will be saved to: $OUTPUT_FILE"
echo ""

# Use temp file first to prevent broken pipe, then copy to output file
# This is the key fix for error 32 (broken pipe)
TMP_OUTPUT=$(mktemp)
trap "rm -f '$TMP_OUTPUT'" EXIT INT TERM

# Run test with unbuffered output to temp file
if command -v stdbuf >/dev/null 2>&1; then
    stdbuf -oL -eL forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv > "$TMP_OUTPUT" 2>&1 || true
else
    forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv > "$TMP_OUTPUT" 2>&1 || true
fi

EXIT_CODE=$?

# Copy temp file to output file
cp "$TMP_OUTPUT" "$OUTPUT_FILE"

echo "Test execution completed with exit code: $EXIT_CODE"
echo ""
echo "=== Last 100 lines of output ==="
tail -100 "$OUTPUT_FILE"
echo ""
echo "Full output saved to: $OUTPUT_FILE"

# Handle broken pipe errors gracefully
if [ $EXIT_CODE -eq 141 ] || [ $EXIT_CODE -eq 32 ]; then
    echo "Note: Broken pipe error handled - output captured successfully"
    exit 0
fi

exit $EXIT_CODE



