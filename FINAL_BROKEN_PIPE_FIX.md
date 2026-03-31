# Final Broken Pipe Fix - Progress Indicator Issue

## Root Cause Identified

The broken pipe error is happening because **forge's progress indicators** (`[⠊]`, `[⠒]`) are causing issues when writing to stdout/stderr. This happens even in interactive terminals.

## The Problem

When forge compiles, it shows animated progress indicators:
```
[⠊] Compiling...
[⠒] Compiling 20 files with Solc 0.8.30
```

These progress indicators write to the terminal in a way that can trigger broken pipe errors, especially if:
- The terminal doesn't fully support the escape sequences
- Output buffering interacts poorly with the progress updates
- The shell/terminal closes the pipe prematurely

## Solutions

### Solution 1: Use JSON Output (RECOMMENDED)

JSON output doesn't use interactive progress indicators:

```bash
./run_test_json.sh
```

Or manually:
```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow --json | jq
```

### Solution 2: Disable Progress Indicators

Use the no-progress script:

```bash
./run_test_no_progress.sh
```

Or manually with color disabled:
```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv --color never
```

### Solution 3: Compile Separately, Then Test

Compile first (quietly), then run tests:

```bash
# Compile without progress indicators
forge build --quiet

# Then run tests (progress indicators are less problematic during test execution)
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv
```

### Solution 4: Use Quiet Mode for Compilation

```bash
# Compile quietly
forge build --quiet

# Run tests with JSON output (no progress indicators)
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow --json
```

### Solution 5: Save to File First

Avoid terminal interaction entirely:

```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv > test.log 2>&1
cat test.log
```

## Why This Works

1. **JSON output**: No progress indicators, just structured data
2. **--color never**: Disables color codes that can cause issues
3. **Separate compilation**: Progress indicators only during build, not test
4. **File output**: No terminal interaction at all

## Quick Test

Try this first:

```bash
cd /Users/acc/ens-vulns
export ALCHEMY_API_KEY="ciDQECovJQpXvHppjWJrf"
./run_test_no_progress.sh
```

This should work because it:
- Compiles quietly (no progress indicators)
- Runs tests with color disabled
- Handles broken pipe errors gracefully

## All Available Scripts

1. `run_test_no_progress.sh` - **Try this first** - Disables progress indicators
2. `run_test_json.sh` - Uses JSON output (requires jq)
3. `run_test_direct.sh` - Direct execution (may still have issues)
4. `run_reentrancy_test.sh` - Original script with temp file handling

## Expected Behavior

With the no-progress script, you should see:
- Clean compilation (no progress spinners)
- Test execution without broken pipe errors
- Full test output displayed

The key is avoiding the interactive progress indicators that forge uses during compilation.
