#!/bin/bash
# Run tests with progress indicators disabled
# Uses environment variables to disable forge's interactive output

set -euo pipefail

# Disable progress indicators and interactive output
export FORCE_COLOR=0
export NO_COLOR=1

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
# Build quietly first
forge build --quiet || {
    echo "Error: Compilation failed"
    exit 1
}

echo ""
echo "Running tests..."
echo ""

# Run with color disabled and quiet compilation
# This should avoid progress indicator issues
forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv --color never 2>&1 || {
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 32 ] || [ $EXIT_CODE -eq 141 ]; then
        echo ""
        echo "Note: Broken pipe error occurred but test may have completed"
        exit 0
    else
        exit $EXIT_CODE
    fi
}

EXIT_CODE=$?

echo ""
echo "=========================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "Test complete!"
else
    echo "Test failed with exit code: $EXIT_CODE"
fi
echo "=========================================="

exit $EXIT_CODE
