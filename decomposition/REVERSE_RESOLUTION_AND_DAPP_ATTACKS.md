# Reverse Resolution and DApp JavaScript Attack Vectors

## Attack Vector 1: Reverse Resolution Exploit

### How Reverse Resolution Works

When registering a name with `reverseRecord` set, the controller calls:

```solidity
if (registration.reverseRecord & REVERSE_RECORD_ETHEREUM_BIT != 0)
    reverseRegistrar.setNameForAddr(
        msg.sender,           // The address to set reverse for
        msg.sender,           // Owner of the reverse record
        registration.resolver, // ⚠️ RESOLVER IS PASSED HERE
        string.concat(registration.label, ".eth")
    );
```

### Critical Finding: Resolver is Passed to Reverse Registrar

The `registration.resolver` (which could be the malicious resolver) is passed to `setNameForAddr()`. This means:

1. **The malicious resolver could be set as the resolver for the reverse record**
2. **The reverse record resolves address → name**
3. **If malicious resolver is used, it could return malicious names**

### Potential Exploit

**Scenario**: Attacker registers "testreentrancy.eth" with malicious resolver and sets `reverseRecord = 1`

1. Controller sets forward resolution: `testreentrancy.eth` → attacker's address
2. Controller sets reverse resolution: attacker's address → `testreentrancy.eth`
3. **The malicious resolver is used for BOTH forward AND reverse resolution**

**Impact**:
- When someone queries reverse (address → name), they get "testreentrancy.eth"
- But the malicious resolver could return ANY name it wants
- This could be used for impersonation attacks

### Testing This

We need to check:
1. Can the malicious resolver implement `name()` function for reverse resolution?
2. Can it return arbitrary names when queried for reverse resolution?
3. Does this happen during the reentrancy window or after?

## Attack Vector 2: DApp JavaScript Tampering

### The Attack

**Scenario**: Malicious JavaScript in a DApp modifies the resolver address before sending the transaction.

### How It Works

1. **User visits compromised DApp** (XSS, malicious dependency, etc.)
2. **DApp JavaScript intercepts registration transaction**
3. **JavaScript modifies `registration.resolver` to attacker's resolver**
4. **Transaction is sent with malicious resolver**
5. **User unknowingly registers with malicious resolver**

### Example Attack Flow

```javascript
// Original registration (what user expects)
const registration = {
    label: "myname",
    owner: userAddress,
    resolver: PUBLIC_RESOLVER_ADDRESS, // User expects this
    // ...
};

// Malicious JavaScript intercepts and modifies
const maliciousRegistration = {
    ...registration,
    resolver: ATTACKER_RESOLVER_ADDRESS, // Changed!
};

// Transaction sent with malicious resolver
await controller.register(maliciousRegistration);
```

### Why This Works

1. **JavaScript runs in user's browser** - has full control over transaction data
2. **User signs transaction** - but doesn't see the resolver address change
3. **Transaction executes** - with malicious resolver
4. **User owns name** - but resolver is malicious

### Real-World Attack Scenarios

1. **XSS in DApp**: Attacker injects malicious JavaScript
2. **Compromised dependency**: Malicious npm package modifies transactions
3. **Browser extension**: Malicious extension intercepts and modifies transactions
4. **Man-in-the-middle**: If DApp loads resources over HTTP (not HTTPS)

### Impact

- **Fund redirection**: Name resolves to attacker's address
- **Phishing**: Malicious text records (URL, email)
- **Impersonation**: Name appears legitimate but resolves maliciously

### Mitigation

1. **Always verify resolver address** before signing
2. **Use transaction simulation** to see what will happen
3. **Validate resolver in DApp** before sending transaction
4. **Use Content Security Policy** to prevent XSS
5. **Audit dependencies** for malicious code

## Combined Attack: Reverse Resolution + DApp Tampering

### The Ultimate Attack

1. **DApp JavaScript modifies resolver** to malicious resolver
2. **Registration includes reverse record** (`reverseRecord = 1`)
3. **Malicious resolver is set for BOTH forward and reverse**
4. **Attacker controls both directions**:
   - Forward: `name.eth` → attacker's address
   - Reverse: attacker's address → `name.eth` (or any name)

### Impact

- User thinks they registered with PublicResolver
- But malicious resolver controls both directions
- Attacker can return any address/name they want
- User's funds go to attacker when sending to name
- Attacker's address appears to resolve to legitimate name

## Testing These Attack Vectors

### Test 1: Reverse Resolution with Malicious Resolver

```solidity
// In test
Registration memory reg = Registration({
    // ...
    resolver: address(maliciousResolver),
    reverseRecord: 1, // Set reverse record
    // ...
});

// Check if malicious resolver is used for reverse
// Query reverse: attacker's address → name
// Malicious resolver should return name
```

### Test 2: DApp JavaScript Tampering

This is harder to test in Solidity, but we can:
1. Document the attack vector
2. Show how JavaScript could modify the transaction
3. Recommend mitigations

## Recommendations

1. **Add ReentrancyGuard** - Defense in depth
2. **Validate resolver in DApp** - Check resolver address before sending
3. **User warnings** - Warn users about custom resolvers
4. **Transaction preview** - Show full registration details before signing
5. **Resolver whitelist** - Optionally allow only trusted resolvers
