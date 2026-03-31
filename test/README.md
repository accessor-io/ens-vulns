# Reentrancy Test Setup

This directory contains tests for the ETHRegistrarController reentrancy vulnerability.

## Setup

1. Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

2. Install dependencies:
```bash
forge install foundry-rs/forge-std
forge install dapphub/ds-test
```

3. Set up environment variables (optional, for mainnet fork):
```bash
export ETHERSCAN_API_KEY=your_key_here
export ALCHEMY_API_KEY=your_key_here  # Or use Infura
```

## Running Tests

### Test on Mainnet Fork

```bash
# Fork mainnet and run tests
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY -vvv

# Or use local node
forge test --fork-url http://localhost:8545 -vvv
```

### Test Specific Function

```bash
forge test --match-test testReentrancyWindow -vvv
forge test --match-test testENSRecordManipulation -vvv
```

## Test Scenarios

1. **testReentrancyWindow**: Tests all reentrancy scenarios
   - Re-enter register()
   - Call renew()
   - Manipulate ENS records

2. **testENSRecordManipulation**: Specifically tests ENS record manipulation

## Expected Results

- Re-entering register() should FAIL (prevented by design)
- Calling renew() might SUCCEED (needs verification)
- Manipulating ENS records might SUCCEED if resolver is PublicResolver

## Notes

- Tests fork mainnet at block 19000000 (adjust as needed)
- Requires test name to be available (change `testLabel` if needed)
- Commitment age is 60 seconds on mainnet (adjust `vm.warp` accordingly)



