# Malicious Resolver Contracts

## Overview

These contracts demonstrate critical vulnerabilities in ENS resolution where malicious resolvers can perform man-in-the-middle attacks to redirect funds.

## Contracts

### 1. MaliciousResolver.sol

Basic malicious resolver that:
- Intercepts all `addr()` calls
- Queries PublicResolver for correct addresses
- Returns attacker's address instead
- Supports reverse resolution attacks

**Attack Flow:**
```
User → maliciousResolver.addr(node)
     ↓
Queries PublicResolver (gets correct address)
     ↓
Returns attacker address (NOT correct address)
     ↓
User sends funds to attacker
```

### 2. MaliciousResolverAdvanced.sol

Advanced version with:
- Selective targeting (only attack specific names)
- Dynamic malicious addresses (different addresses per name)
- Enhanced obfuscation (emits events)
- Attack mode toggle (attack all vs targeted only)

**Use Cases:**
- Target specific high-value names
- Use different addresses for different names
- Appear legitimate for non-targeted names

## Attack Vectors

### 1. Man-in-the-Middle Attack

**How it works:**
1. Malicious resolver intercepts `addr()` calls
2. Queries PublicResolver to get correct address (for obfuscation)
3. Returns malicious address instead
4. User sends funds to attacker

**Impact:**
- Fund theft
- Hard to detect (resolver looks legitimate)
- Works for any name using malicious resolver

### 2. Reverse Resolution Attack

**How it works:**
1. Malicious resolver implements `name()` for reverse resolution
2. Returns arbitrary names (e.g., "vitalik.eth" for impersonation)
3. Attacker's address appears to resolve to legitimate name

**Impact:**
- Impersonation attacks
- Social engineering
- Trust exploitation

### 3. Obfuscation

**How it works:**
1. Queries PublicResolver to appear legitimate
2. Emits events to make logs look normal
3. Stores intercepted addresses for tracking

**Impact:**
- Harder to detect
- Debugging is more difficult
- Events look legitimate

## Deployment

### Basic Resolver

```solidity
// Deploy with:
// - ENS registry address
// - PublicResolver address
// - Attacker address (address to return)
MaliciousResolver resolver = new MaliciousResolver(
    0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e, // ENS
    0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41, // PublicResolver
    0xATTACKER_ADDRESS // Attacker
);
```

### Advanced Resolver

```solidity
// Deploy with same parameters
MaliciousResolverAdvanced resolver = new MaliciousResolverAdvanced(
    0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e, // ENS
    0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41, // PublicResolver
    0xATTACKER_ADDRESS // Default attacker
);

// Target specific names
resolver.targetNode(namehash("vitalik.eth"), 0xSPECIFIC_ATTACKER);
resolver.setAttackMode(false); // Only attack targeted names
```

## Usage in Attacks

### Scenario 1: DApp JavaScript Tampering

1. Malicious JavaScript modifies resolver address
2. User registers name with malicious resolver
3. User queries name → gets attacker address
4. User sends funds to attacker

### Scenario 2: Reverse Resolution

1. Attacker registers name with malicious resolver
2. Sets `reverseRecord = 1` during registration
3. Malicious resolver is used for reverse resolution
4. Attacker's address appears to resolve to legitimate name

### Scenario 3: Selective Targeting

1. Deploy advanced resolver
2. Target high-value names only
3. Non-targeted names resolve correctly (appears legitimate)
4. Targeted names redirect funds

## Detection

### Signs of Attack

1. Resolver address is not PublicResolver
2. Resolved address doesn't match PublicResolver's address
3. Events show resolution but funds go to wrong address

### How to Check

```solidity
// Check resolver
address resolver = ens.resolver(namehash);
if (resolver != PUBLIC_RESOLVER_ADDRESS) {
    // WARNING: Custom resolver!
}

// Compare addresses
address publicAddr = publicResolver.addr(namehash);
address resolvedAddr = IAddrResolver(resolver).addr(namehash);
if (publicAddr != resolvedAddr) {
    // ATTACK: Addresses don't match!
}
```

## Mitigation

1. **Always verify resolver address** before trusting resolution
2. **Compare with PublicResolver** - If resolver is not PublicResolver, double-check
3. **User warnings** - Warn users about custom resolvers
4. **Transaction preview** - Show resolved address before sending
5. **Resolver whitelist** - Only allow trusted resolvers in DApps
6. **DApp security** - Prevent JavaScript tampering (CSP, SRI, etc.)

## Security Notes

⚠️ **WARNING**: These contracts are for educational and security research purposes only. Do not deploy to mainnet or use for malicious purposes.

## Testing

See `test/ReentrancyTest.t.sol` for comprehensive tests demonstrating these attacks.
