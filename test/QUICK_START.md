# Quick Start - Reentrancy Testing

## Prerequisites

1. Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

2. Get an RPC URL (Alchemy, Infura, or local node)

## Run Tests

```bash
# Setup
./test/setup.sh

# Run tests
export RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY
./test/run_tests.sh
```

Or manually:
```bash
forge test --fork-url $RPC_URL -vvv --match-path "test/ReentrancyTest.t.sol"
```

## What the Tests Do

1. **Fork mainnet** at a recent block
2. **Deploy malicious resolver** that attempts exploits during reentrancy
3. **Register a name** with the malicious resolver
4. **Test three scenarios**:
   - Re-enter register() (should fail)
   - Call renew() (might succeed)
   - Manipulate ENS records (might succeed)

## Expected Output

The tests will show:
- Whether reentrancy was attempted
- Results of each exploit attempt
- Final state of ENS records
- Whether malicious records were set

## Troubleshooting

- **Name not available**: Change `testLabel` in the test file
- **RPC errors**: Check your API key and quota
- **Compilation errors**: Run `./test/setup.sh` to install dependencies



