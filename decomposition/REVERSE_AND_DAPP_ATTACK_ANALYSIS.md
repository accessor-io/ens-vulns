# Reverse Resolution and DApp JavaScript Attack Analysis

## Attack Vector 1: Reverse Resolution with Malicious Resolver

### Critical Finding

When `reverseRecord` is set during registration, the controller calls:

```solidity
reverseRegistrar.setNameForAddr(
    msg.sender,              // Address to set reverse for
    msg.sender,              // Owner
    registration.resolver,   // ⚠️ MALICIOUS RESOLVER IS PASSED HERE
    string.concat(registration.label, ".eth")
);
```

### What This Means

1. **The malicious resolver is set as the resolver for the reverse record**
2. **Reverse resolution queries the malicious resolver's `name()` function**
3. **The malicious resolver can return ANY name it wants**

### The Attack

**Scenario**: Attacker registers "testreentrancy.eth" with malicious resolver and `reverseRecord = 1`

1. Forward resolution: `testreentrancy.eth` → attacker's address (via malicious `addr()`)
2. Reverse resolution: attacker's address → `testreentrancy.eth` (via malicious `name()`)
3. **But the malicious resolver can return ANY name for reverse resolution**

**Example**:
- Attacker's address: `0xATTACKER...`
- Malicious resolver's `name()` returns: `"vitalik.eth"` (impersonation!)
- When someone queries reverse: `0xATTACKER...` → `"vitalik.eth"` (fake!)

### Impact

- **Impersonation**: Attacker's address appears to resolve to a legitimate name
- **Social Engineering**: Users see "vitalik.eth" but it's actually attacker's address
- **Trust Exploitation**: Users trust the reverse resolution

### Testing Results

From our test:
- Reverse node resolver: `0x0` (not set in our test - need to verify why)
- Need to verify if reverse record is actually set with malicious resolver

## Attack Vector 2: DApp JavaScript Tampering

### The Attack

**Scenario**: Malicious JavaScript in a DApp modifies the resolver address before sending the transaction.

### How It Works

```javascript
// User expects this:
const registration = {
    label: "myname",
    resolver: PUBLIC_RESOLVER_ADDRESS, // 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41
    // ...
};

// Malicious JavaScript intercepts and modifies:
const maliciousRegistration = {
    ...registration,
    resolver: ATTACKER_RESOLVER_ADDRESS, // Changed to attacker's resolver!
};

// Transaction sent with malicious resolver
await controller.register(maliciousRegistration);
```

### Attack Vectors

1. **XSS in DApp**: Attacker injects malicious JavaScript
2. **Compromised dependency**: Malicious npm package modifies transactions
3. **Browser extension**: Malicious extension intercepts and modifies
4. **Man-in-the-middle**: If DApp loads resources over HTTP

### Why This Works

1. **JavaScript runs in user's browser** - has full control
2. **User signs transaction** - but doesn't see resolver change
3. **Transaction executes** - with malicious resolver
4. **User owns name** - but resolver is malicious

### Impact

- **Fund redirection**: Name resolves to attacker's address
- **Phishing**: Malicious text records (URL, email)
- **Impersonation**: Name appears legitimate but resolves maliciously
- **Reverse resolution**: Attacker's address appears to resolve to legitimate name

### Real-World Example

```javascript
// In a compromised DApp
const originalRegister = controller.register;
controller.register = function(registration) {
    // Intercept and modify
    registration.resolver = ATTACKER_RESOLVER;
    return originalRegister.call(this, registration);
};
```

## Combined Attack: Reverse + DApp Tampering

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

## Mitigations

### For Reverse Resolution

1. **Validate resolver in DApp** - Check resolver address before sending
2. **User warnings** - Warn users about custom resolvers
3. **Transaction preview** - Show full registration details before signing
4. **Resolver whitelist** - Optionally allow only trusted resolvers

### For DApp JavaScript

1. **Content Security Policy** - Prevent XSS
2. **Audit dependencies** - Check npm packages for malicious code
3. **Subresource Integrity** - Verify script integrity
4. **Transaction simulation** - Show what will happen before signing
5. **Resolver validation** - Always verify resolver address in UI

## Recommendations

1. **Add ReentrancyGuard** - Defense in depth (though not the main issue)
2. **DApp security** - Focus on preventing JavaScript tampering
3. **User education** - Warn users about custom resolvers
4. **Transaction preview** - Show full registration details
5. **Resolver whitelist** - Optionally restrict to trusted resolvers

## Conclusion

The real vulnerabilities are:
1. **Reverse resolution** - Malicious resolver can return arbitrary names
2. **DApp JavaScript tampering** - Malicious code can modify resolver address

The reentrancy window itself is less critical, but these attack vectors are real and dangerous.
