# Broken Pipe Error 32 - Final Solution

## The Problem

Even when running `forge test` directly in an interactive terminal, you're getting:
```
Error: Broken pipe (os error 32)
```

This is unusual and suggests that forge itself may be detecting something about the output stream that causes it to close early.

## Root Cause Analysis

The broken pipe error occurs because:
1. Forge writes output in a way that can trigger SIGPIPE
2. The terminal or shell may be closing the pipe prematurely
3. Output buffering issues between forge and the terminal

## Solutions

### Solution 1: Run Directly Without Scripts (BEST)

The simplest solution is to run forge test directly without any wrapper:

```bash
cd /Users/acc/ens-vulns
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv
```

If this still gives broken pipe, try:

```bash
# Ignore broken pipe errors explicitly
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv 2>&1 || [ $? -eq 32 -o $? -eq 141 ] || true
```

### Solution 2: Use Direct Runner Script

I've created `run_test_direct.sh` which runs forge without any output redirection:

```bash
./run_test_direct.sh
```

This script:
- Runs forge directly (no output redirection)
- Lets forge write directly to terminal
- Avoids broken pipe issues entirely

### Solution 3: Use Output File

Save output to a file and view it:

```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv > test_output.log 2>&1
cat test_output.log
```

### Solution 4: Lower Verbosity

Sometimes lower verbosity helps:

```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -v
```

### Solution 5: Use Different Terminal

Try running in a different terminal emulator or use `screen`/`tmux`:

```bash
screen
# Then run your forge test command
forge test --fork-url '...' --match-test testReentrancyWindow -vv
```

## Why This Happens

The broken pipe error (32) occurs when:
- A process tries to write to a pipe that has been closed
- The receiving end (terminal/shell) closes before all data is written
- Forge's output buffering interacts poorly with the terminal

## Recommended Approach

**For your specific case**, since you have the Alchemy API key, I recommend:

```bash
cd /Users/acc/ens-vulns
export ALCHEMY_API_KEY="ciDQECovJQpXvHppjWJrf"
./run_test_direct.sh
```

Or run directly:

```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/ciDQECovJQpXvHppjWJrf' --match-test testReentrancyWindow -vv 2>&1 | cat
```

The `| cat` at the end can help prevent broken pipes by keeping the pipe open.

## Testing

To verify which solution works for you:

1. Try `run_test_direct.sh` first
2. If that fails, try the direct command with `| cat`
3. If that fails, try saving to a file
4. If all else fails, try a different terminal or lower verbosity

The key is avoiding output redirection that can cause forge to detect a closed pipe.


