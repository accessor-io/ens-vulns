#!/bin/bash
# Direct test runner - runs forge test without output redirection
# This avoids broken pipe issues by letting forge write directly to terminal

set -euo pipefail

# Use environment variable for RPC URL, with fallback
if [ -z "${ALCHEMY_API_KEY:-}" ]; then
    echo "Warning: ALCHEMY_API_KEY not set. Using default public RPC."
    RPC_URL="${RPC_URL:-https://eth.llamarpc.com}"
else
    RPC_URL="https://eth-mainnet.g.alchemy.com/v2/$ALCHEMY_API_KEY"
fi

echo "=========================================="
echo "ETHRegistrarController Reentrancy Test"
echo "=========================================="
echo ""
echo "RPC URL: $RPC_URL"
echo ""

cd "$(dirname "$0")"

echo "Compiling..."
forge build --quiet || {
    echo "Error: Compilation failed"
    exit 1
}

echo ""
echo "Running tests..."
echo ""

# Run directly without redirection - let forge write to terminal
# This avoids broken pipe issues entirely
forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv

EXIT_CODE=$?

echo ""
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "Test complete!"
elif [ $EXIT_CODE -eq 32 ] || [ $EXIT_CODE -eq 141 ]; then
    echo "Test completed (broken pipe handled)"
else
    echo "Test failed with exit code: $EXIT_CODE"
fi
echo "=========================================="

exit $EXIT_CODE


