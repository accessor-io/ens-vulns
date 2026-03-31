# Final Run Instructions

## Test Setup Complete ✅

All files are configured and ready. The test can be run manually in your terminal.

## Run Command

```bash
cd /Users/acc/ens-vulns

# Set Alchemy API key
export ALCHEMY_API_KEY="ciDQECovJQpXvHppjWJrf"

# Run test
forge test --fork-url "https://eth-mainnet.g.alchemy.com/v2/$ALCHEMY_API_KEY" --match-test testReentrancyWindow -vv
```

## What Will Happen

1. **Compile** test contracts (20 files)
2. **Fork mainnet** at block 19000000
3. **Deploy** malicious resolver contract
4. **Register** test name "testreentrancy" 
5. **Test** three reentrancy scenarios:
   - Re-enter register() - Should FAIL
   - Call renew() - Might SUCCEED
   - Manipulate ENS records - Might SUCCEED

## Expected Output

You should see:
- Compilation messages
- Test execution logs
- Console output showing:
  - "=== REENTRANCY WINDOW OPENED ==="
  - State at reentrancy point
  - Results of each exploit attempt
  - "=== REENTRANCY WINDOW CLOSED ==="
  - Final ENS record state

## Test Results to Verify

1. **Re-enter register()**: Should fail (commitment deleted, name registered)
2. **Call renew()**: Check if it succeeds and extends expiration
3. **Manipulate ENS records**: Check if malicious records are set

## Files Ready

- ✅ `test/ReentrancyTest.t.sol` - Test contract
- ✅ `foundry.toml` - Configuration  
- ✅ Dependencies installed
- ✅ Alchemy API configured

Run the command above in your terminal to see the test results!



