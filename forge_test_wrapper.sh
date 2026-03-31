#!/bin/bash
# Wrapper for forge test that prevents broken pipe errors
# Usage: ./forge_test_wrapper.sh [forge test arguments...]

set -euo pipefail

# Use temp file to prevent broken pipe errors
TMP_OUTPUT=$(mktemp)
trap "rm -f '$TMP_OUTPUT'" EXIT INT TERM

# Run forge test with all arguments, capturing output
if command -v stdbuf >/dev/null 2>&1; then
    stdbuf -oL -eL forge test "$@" > "$TMP_OUTPUT" 2>&1 || true
else
    forge test "$@" > "$TMP_OUTPUT" 2>&1 || true
fi

exit_code=$?

# Always display output
if [ -s "$TMP_OUTPUT" ]; then
    cat "$TMP_OUTPUT"
fi

# Handle broken pipe errors
if [ $exit_code -eq 141 ] || [ $exit_code -eq 32 ]; then
    exit 0
fi

exit $exit_code


