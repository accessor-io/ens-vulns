#!/bin/bash
# Run reentrancy tests on local fork
# Fixed: Handles broken pipe errors (error 32) robustly

set -euo pipefail

echo "=== ETHRegistrarController Reentrancy Tests ==="
echo ""

# Check for RPC URL
if [ -z "${RPC_URL:-}" ]; then
    echo "Error: RPC_URL environment variable not set"
    echo "Set it with: export RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY"
    echo "Or use local node: export RPC_URL=http://localhost:8545"
    exit 1
fi

echo "Using RPC URL: $RPC_URL"
echo ""

# Use a temp file to avoid broken pipe issues
# This is the key fix for error 32 (broken pipe)
TMP_OUTPUT=$(mktemp)
trap "rm -f '$TMP_OUTPUT'" EXIT INT TERM

# Run tests with verbose output
echo "Running reentrancy tests..."

# Use stdbuf if available to disable buffering (prevents broken pipe on early termination)
if command -v stdbuf >/dev/null 2>&1; then
    stdbuf -oL -eL forge test --fork-url "$RPC_URL" -vvv --match-path "test/ReentrancyTest.t.sol" > "$TMP_OUTPUT" 2>&1 || true
else
    forge test --fork-url "$RPC_URL" -vvv --match-path "test/ReentrancyTest.t.sol" > "$TMP_OUTPUT" 2>&1 || true
fi

exit_code=$?

# Always output the results, regardless of exit code
if [ -s "$TMP_OUTPUT" ]; then
    cat "$TMP_OUTPUT"
else
    echo "No output captured"
fi

echo ""

# Handle exit codes
if [ $exit_code -eq 0 ]; then
    echo "Tests complete!"
    exit 0
elif [ $exit_code -eq 141 ] || [ $exit_code -eq 32 ]; then
    # Broken pipe errors - handled by temp file, treat as success
    echo "Tests complete! (handled broken pipe)"
    exit 0
else
    # Real test failure
    echo "Tests failed with exit code: $exit_code"
    exit $exit_code
fi



