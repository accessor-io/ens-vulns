# Run Reentrancy Tests - Instructions

## Quick Run

Execute this command in your terminal:

```bash
cd /Users/acc/ens-vulns
./run_reentrancy_test.sh
```

Or run directly:

```bash
cd /Users/acc/ens-vulns

# Set your Alchemy API key (or use public RPC)
export ALCHEMY_API_KEY="your_api_key_here"
# Or use public RPC:
# export RPC_URL="https://eth.llamarpc.com"

# Run the test script
./run_reentrancy_test.sh

# Or run directly:
forge test --fork-url "${RPC_URL:-https://eth.llamarpc.com}" --match-test testReentrancyWindow -vv
```

## What Will Happen

1. **Fork mainnet** at block 19000000
2. **Deploy malicious resolver** contract
3. **Register test name** "testreentrancy" with malicious resolver
4. **Test three scenarios**:
   - Re-enter register() (should fail - prevented)
   - Call renew() (might succeed)
   - Manipulate ENS records (might succeed if PublicResolver)

## Expected Output

You should see:
- Compilation messages
- Test execution logs
- Reentrancy window state
- Results of each exploit attempt
- Final ENS record state
- Whether malicious records were set

## Test Results to Look For

### Test 1: Re-enter register()
- **Expected**: FAIL
- **Reason**: Commitment deleted, name registered

### Test 2: Call renew()
- **Expected**: Might SUCCEED
- **Check**: Does it extend expiration?

### Test 3: Manipulate ENS Records
- **Expected**: Might SUCCEED
- **Check**: Are malicious records set?

## Troubleshooting

If you see errors:
- **"Name not available"**: Change `testLabel` in test file
- **"Insufficient value"**: Increase payment amount
- **RPC errors**: Check API key is valid

## Files Ready

- ✅ `test/ReentrancyTest.t.sol` - Test contract
- ✅ `foundry.toml` - Configuration
- ✅ Dependencies installed
- ⚠️ **Set ALCHEMY_API_KEY environment variable** or use public RPC



