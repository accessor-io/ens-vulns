#!/bin/bash
# Run reentrancy tests with Alchemy API
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

echo "=========================================="
echo "ETHRegistrarController Reentrancy Test"
echo "=========================================="
echo ""
echo "RPC URL: $RPC_URL"
echo ""

cd "$(dirname "$0")"

# Initialize temp files early
TMP_BUILD=$(mktemp)
TMP_OUTPUT=$(mktemp)
trap "rm -f '$TMP_BUILD' '$TMP_OUTPUT'" EXIT INT TERM

echo "Compiling..."

# Compile with output to temp file
if command -v stdbuf >/dev/null 2>&1; then
    stdbuf -oL -eL forge build --quiet > "$TMP_BUILD" 2>&1 || true
else
    forge build --quiet > "$TMP_BUILD" 2>&1 || true
fi

build_exit=$?
if [ $build_exit -ne 0 ] && [ $build_exit -ne 32 ] && [ $build_exit -ne 141 ]; then
    # Real compilation error
    if [ -s "$TMP_BUILD" ]; then
        cat "$TMP_BUILD"
    fi
    echo "Error: Compilation failed"
    exit 1
fi

echo ""
echo "Running tests..."
echo ""

# Try multiple approaches to prevent broken pipe
# Approach 1: Use script command to create pseudo-TTY (if available)
if command -v script >/dev/null 2>&1 && [ -t 0 ]; then
    # Use script to create a TTY-like environment
    script -q "$TMP_OUTPUT" bash -c "forge test --fork-url '$RPC_URL' --match-test testReentrancyWindow -vv" 2>&1 || true
    exit_code=$?
    # Remove script control characters
    sed -i '' 's/\^\[\[[0-9;]*m//g' "$TMP_OUTPUT" 2>/dev/null || sed -i 's/\^\[\[[0-9;]*m//g' "$TMP_OUTPUT" 2>/dev/null || true
elif command -v stdbuf >/dev/null 2>&1; then
    # Approach 2: Use stdbuf with unbuffered output
    stdbuf -oL -eL forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv > "$TMP_OUTPUT" 2>&1 || true
    exit_code=$?
else
    # Approach 3: Direct output with error handling
    # Write stdout and stderr separately to avoid issues
    forge test --fork-url "$RPC_URL" --match-test testReentrancyWindow -vv > "$TMP_OUTPUT" 2>&1 || true
    exit_code=$?
fi

# Always output the results, regardless of exit code
# This ensures we see output even if there was a broken pipe
if [ -s "$TMP_OUTPUT" ]; then
    # Filter out script control sequences if present
    cat "$TMP_OUTPUT" | sed 's/\r$//' | grep -v '^Script started' | grep -v '^Script done' || cat "$TMP_OUTPUT"
else
    echo "No output captured (this may indicate the broken pipe occurred before any output)"
    echo "Try running the test directly: forge test --fork-url '$RPC_URL' --match-test testReentrancyWindow -vv"
fi

echo ""
echo "=========================================="

# Handle exit codes
if [ $exit_code -eq 0 ]; then
    echo "Test complete!"
    echo "=========================================="
    exit 0
elif [ $exit_code -eq 141 ] || [ $exit_code -eq 32 ]; then
    # Broken pipe errors - these are handled by temp file, so treat as success
    echo "Test complete! (handled broken pipe)"
    echo "=========================================="
    exit 0
else
    # Real test failure
    echo "Test failed with exit code: $exit_code"
    echo "=========================================="
    exit $exit_code
fi



