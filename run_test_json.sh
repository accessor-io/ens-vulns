#!/bin/bash
# Run tests using JSON output to avoid progress indicator issues
# JSON output doesn't use interactive progress spinners

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
echo "Using JSON output to avoid broken pipe issues"
echo ""

cd "$(dirname "$0")"

echo "Compiling..."
# Use --quiet to avoid progress indicators during compilation
forge build --quiet || {
    echo "Error: Compilation failed"
    exit 1
}

echo ""
echo "Running tests..."
echo ""

# Use JSON output - this avoids interactive progress indicators
# that can cause broken pipe errors
forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow --json 2>&1 | jq -r '
  if type == "array" then
    .[] | select(.test_results != null) | 
    "Test: \(.name)\nStatus: \(.status)\nGas: \(.gas)\n"
  else
    .
  end
' || {
    # If jq fails or output isn't JSON, just show raw output
    echo "Raw output (JSON parsing failed):"
    forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow --json 2>&1
}

EXIT_CODE=${PIPESTATUS[0]}

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
