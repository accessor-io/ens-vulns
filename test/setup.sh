#!/bin/bash
# Setup script for reentrancy tests

echo "Setting up Foundry test environment..."

# Check if foundry is installed
if ! command -v forge &> /dev/null; then
    echo "Foundry not found. Installing..."
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
fi

# Install dependencies
echo "Installing dependencies..."
forge install foundry-rs/forge-std --no-commit
forge install dapphub/ds-test --no-commit

# Create lib directory if it doesn't exist
mkdir -p lib

echo "Setup complete!"
echo ""
echo "To run tests:"
echo "  forge test --fork-url <RPC_URL> -vvv"
echo ""
echo "Example:"
echo "  forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY -vvv"



