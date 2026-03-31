# ENS Payment Interface - Malicious Resolver Attack Demo

## Overview

This is a mock user interface that demonstrates how a user would unknowingly send funds to an attacker when a malicious resolver is used.

## How It Works

### User Flow

1. **User enters ENS name** (e.g., "vitalik.eth")
2. **User clicks "Resolve Address"**
3. **Interface queries resolver** (could be malicious or legitimate)
4. **Address is displayed** to the user
5. **User sends funds** thinking it's the correct address

### Attack Scenario

When a malicious resolver is used:

1. **User resolves "vitalik.eth"**
2. **Malicious resolver intercepts** the query
3. **Queries PublicResolver** to get correct address: `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`
4. **Returns attacker address** instead: `0x0000000000000000000000000000000000001337`
5. **User sees attacker address** but thinks it's correct
6. **User sends funds** to attacker

### Security Features

The interface includes:
- **Warning system**: Detects when resolved address doesn't match PublicResolver
- **Address comparison**: Shows resolver used vs PublicResolver address
- **Visual indicators**: Green for safe, red for malicious

## Running the Interface

### Option 1: Open Directly

Simply open `index.html` in a web browser.

### Option 2: Local Server

```bash
# Python 3
python3 -m http.server 8000

# Node.js (with http-server)
npx http-server -p 8000

# Then open: http://localhost:8000
```

## Interface Features

### 1. ENS Name Input
- User enters the ENS name they want to send funds to
- Example: "vitalik.eth"

### 2. Amount Input
- User enters the amount of ETH to send
- Example: 1.0 ETH

### 3. Resolve Address Button
- Queries the resolver for the ENS name
- Displays the resolved address
- Shows warning if address doesn't match PublicResolver

### 4. Send Payment Button
- Sends funds to the resolved address
- Shows result (success or attack detected)

### 5. Security Comparison
- Shows which resolver was used
- Compares resolved address with PublicResolver address
- Indicates if addresses match

## Attack Demonstration

### Scenario 1: Legitimate Resolver

```
User resolves: vitalik.eth
Resolver: PublicResolver (0x4976fb03...)
Address: 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
Match: ✅ MATCH
Result: Safe - funds sent to correct address
```

### Scenario 2: Malicious Resolver

```
User resolves: vitalik.eth
Resolver: MaliciousResolver (0x03F1B438...)
PublicResolver Address: 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
Resolved Address: 0x0000000000000000000000000000000000001337
Match: ❌ NO MATCH
Result: ⚠️ Funds sent to attacker!
```

## Real-World Integration

In a real DApp, this would:

1. **Connect to Web3** (MetaMask, WalletConnect, etc.)
2. **Query ENS on-chain** using ethers.js or web3.js
3. **Display resolved address** to user
4. **Send transaction** when user confirms
5. **Verify resolver** before sending (security best practice)

## Security Recommendations

1. **Always verify resolver address** before trusting resolution
2. **Compare with PublicResolver** if resolver is not PublicResolver
3. **Show warnings** when resolver is not PublicResolver
4. **Allow user to verify** before sending funds
5. **Display full address** so user can verify manually

## Files

- `index.html` - Main interface file
- `README.md` - This file
