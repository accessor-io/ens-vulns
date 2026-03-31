# Local Fork Testing Guide

## Quick Start

1. **Setup Foundry** (if not already installed):
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

2. **Install dependencies**:
```bash
./test/setup.sh
```

3. **Run tests on mainnet fork**:
```bash
export RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY
./test/run_tests.sh
```

Or use a local node:
```bash
# Start local node (e.g., with Anvil)
anvil --fork-url https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY

# In another terminal
export RPC_URL=http://localhost:8545
./test/run_tests.sh
```

## Test Scenarios

### Test 1: Re-enter register()

**Expected**: Should FAIL
- Commitment is deleted before external call
- Name is registered before external call
- Re-entering register() will hit `CommitmentNotFound` or `NameNotAvailable` error

### Test 2: Call renew()

**Expected**: Might SUCCEED
- Name exists and is registered to controller
- Controller is authorized to renew
- Could extend expiration before NFT transfer

### Test 3: Manipulate ENS Records

**Expected**: Might SUCCEED if resolver is PublicResolver
- Controller is trusted by PublicResolver
- `isAuthorised()` returns `true` for controller
- Resolver can set arbitrary records during reentrancy

## Understanding the Output

The tests will output:
- Whether reentrancy was attempted
- Results of each exploit attempt
- Final state of ENS records
- Whether malicious records were set

## Customizing Tests

### Change Test Name

Edit `test/ReentrancyTest.t.sol`:
```solidity
string public testLabel = "yourname";  // Change this
```

### Change Fork Block

Edit `test/ReentrancyTest.t.sol`:
```solidity
vm.createSelectFork("mainnet", 19000000);  // Change block number
```

### Enable/Disable Exploits

In the test:
```solidity
maliciousResolver.setExploitENSRecords(true);   // Enable ENS manipulation
maliciousResolver.setExploitRenew(true);        // Enable renew() call
```

## Troubleshooting

### "Name not available"
- The test name is already registered
- Change `testLabel` to an available name
- Or use a different block number where the name was available

### "Commitment too new"
- Need to wait for `minCommitmentAge` (60 seconds on mainnet)
- The test uses `vm.warp(block.timestamp + 61 seconds)`
- Adjust if needed

### "Insufficient value"
- Registration price might be higher
- Adjust the `price` variable in the test

### RPC Errors
- Check your RPC URL is correct
- Ensure you have API credits/quota
- Try a different RPC provider

## Expected Test Results

Based on analysis:

1. **Re-enter register()**: ❌ FAIL (prevented)
2. **Call renew()**: ⚠️ MIGHT SUCCEED (needs verification)
3. **Manipulate ENS records**: ⚠️ MIGHT SUCCEED (if PublicResolver)

## Next Steps

After running tests:

1. Review the console output
2. Check if ENS records were manipulated
3. Verify if renew() succeeded
4. Document findings in `decomposition/REENTRANCY_TEST_RESULTS.md`



