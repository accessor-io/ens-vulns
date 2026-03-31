# Testing Guide - Avoiding Broken Pipe Errors

## Problem
Running `forge test` directly in some terminals or through automated interfaces can result in "Broken pipe (os error 32)" errors.

## Solutions

### Option 1: Use the Fixed Scripts (Recommended)

All test scripts have been fixed to handle broken pipe errors:

```bash
# Main reentrancy test
./run_reentrancy_test.sh

# Simple test runner
./run_test.sh

# Test directory runner
./test/run_tests.sh

# Simple runner with file output
./run_test_simple.sh
```

### Option 2: Use the Wrapper Script

For direct `forge test` commands, use the wrapper:

```bash
# Instead of: forge test --fork-url ... -vv
./forge_test_wrapper.sh --fork-url https://eth.llamarpc.com --match-test testReentrancyWindow -vv
```

### Option 3: Manual Terminal Workaround

If running `forge test` directly in your terminal, you can:

1. **Use a temporary file:**
```bash
TMP=$(mktemp)
forge test --fork-url "$RPC_URL" -vv > "$TMP" 2>&1 || true
cat "$TMP"
rm "$TMP"
```

2. **Use stdbuf (if available):**
```bash
stdbuf -oL -eL forge test --fork-url "$RPC_URL" -vv
```

3. **Ignore broken pipe errors:**
```bash
forge test --fork-url "$RPC_URL" -vv 2>&1 || [ $? -eq 32 ] || [ $? -eq 141 ]
```

### Option 4: Direct Execution (No Piping)

If you're running in an interactive terminal, you can run directly without any redirection:

```bash
forge test --fork-url https://eth.llamarpc.com --match-test testReentrancyWindow -vv
```

This should work fine in most interactive terminals.

## Understanding the Error

The broken pipe error (32) occurs when:
- Output is piped or redirected
- The receiving process closes before all data is written
- Output buffering causes early termination

## All Fixed Scripts

1. ✅ `run_reentrancy_test.sh` - Main reentrancy test runner
2. ✅ `run_test.sh` - Simple test runner
3. ✅ `test/run_tests.sh` - Test directory runner
4. ✅ `run_test_simple.sh` - Simple runner with file output
5. ✅ `forge_test_wrapper.sh` - Wrapper for direct forge test commands

## Quick Test

To verify everything works:

```bash
# Test the wrapper
./forge_test_wrapper.sh --help

# Test a simple command
./forge_test_wrapper.sh --list
```

All scripts handle broken pipe errors gracefully and will display output even if the error occurs.


