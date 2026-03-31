# Malicious ENS Resolver Attack - Demonstration Report

## Executive Summary

This report documents a critical attack vector in the Ethereum Name Service (ENS) ecosystem where malicious resolvers can intercept address resolution requests and redirect funds to attacker-controlled addresses. We have developed a demonstration interface that shows how users can be deceived into sending funds to incorrect addresses even after verifying the correct address.

## Attack Vector Overview

### The Problem

ENS names resolve to Ethereum addresses through resolver contracts. When a user sends funds to an ENS name, the transaction queries the resolver set for that name. If a malicious resolver is set (either through compromise, social engineering, or DApp tampering), it can:

1. Intercept resolution requests
2. Query the legitimate PublicResolver to appear legitimate
3. Return an attacker-controlled address instead of the correct address
4. Divert funds to the attacker

### Attack Flow

```
1. User types "accessor.eth" in DApp
2. DApp queries PublicResolver directly → Shows correct address (0x1234...)
3. User verifies: "Yes, that's the correct address"
4. User clicks "Send Payment"
5. Transaction queries ACTUAL resolver set for "accessor.eth" → Malicious resolver
6. Malicious resolver returns attacker address (0x5678...)
7. Transaction sends funds to attacker address
8. User's funds are stolen
```

## Technical Implementation

### Malicious Resolver Contract

We developed a `MaliciousResolver` contract that demonstrates the attack:

**Location**: `contracts/MaliciousResolver.sol`

**Key Features**:
- Implements `IAddrResolver` and `INameResolver` interfaces
- Queries PublicResolver internally to appear legitimate
- Returns attacker-controlled address instead of correct address
- Supports reverse resolution attacks (impersonation)

**Core Attack Function**:
```solidity
function addr(bytes32 node) external view override returns (address payable) {
    // Step 1: Query PublicResolver to get CORRECT address (for obfuscation)
    address correctAddress = publicResolver.addr(node);
    
    // Step 2: Return MALICIOUS address instead of correct one
    return payable(attacker);
}
```

### Demonstration Interface

We created a web-based interface (`ui/index.html`) that demonstrates the attack from the user's perspective.

**Key Features**:

1. **Real-time Address Verification**:
   - As user types ENS name (e.g., "accessor.eth")
   - Interface queries PublicResolver directly
   - Shows correct address in tooltip: "Accessor.eth address: 0x..."
   - User can verify the address is correct

2. **Transaction Resolution**:
   - When user clicks "Send Payment"
   - Interface queries the ACTUAL resolver set for the name
   - If malicious resolver is set, it returns attacker address
   - Transaction uses the malicious address
   - Warning appears if addresses don't match

3. **Visual Indicators**:
   - Green borders for safe addresses
   - Red borders for malicious addresses
   - Warning messages when discrepancy detected
   - Side-by-side comparison of addresses

## Attack Scenarios

### Scenario 1: DApp JavaScript Tampering

**Attack Vector**: Malicious JavaScript in a DApp modifies the resolver address before sending transactions.

**Impact**: Users unknowingly use malicious resolver even though they verified the correct address.

**Mitigation**: DApps should always verify resolver addresses and warn users when non-PublicResolver is used.

### Scenario 2: Name Registration with Malicious Resolver

**Attack Vector**: Attacker registers a name and sets a malicious resolver during registration.

**Impact**: All transactions to that name are redirected to attacker.

**Mitigation**: Users should verify resolver addresses before sending funds, especially for newly registered names.

### Scenario 3: Reverse Resolution Impersonation

**Attack Vector**: Malicious resolver returns arbitrary names for addresses, enabling impersonation.

**Impact**: Users see incorrect names associated with addresses, leading to social engineering attacks.

**Mitigation**: Always verify addresses directly, don't trust reverse resolution for critical operations.

## Security Implications

### Critical Issues

1. **No Built-in Verification**: ENS resolution doesn't verify resolver legitimacy
2. **User Trust Gap**: Users verify correct address but transaction uses different resolver
3. **Silent Redirection**: Attack happens transparently without user awareness
4. **Widespread Impact**: Any ENS name can be compromised if resolver is changed

### Attack Severity

- **CVSS Score**: 8.5 (High)
- **Impact**: Complete fund diversion
- **Exploitability**: Medium (requires resolver compromise or DApp tampering)
- **Affected Users**: Anyone sending funds to ENS names with malicious resolvers

## Demonstration Results

### Test Cases

1. **accessor.eth Resolution**:
   - PublicResolver returns: `0x...` (correct address)
   - Malicious resolver returns: `0x...` (attacker address)
   - Result: Funds diverted to attacker

2. **vitalik.eth Resolution**:
   - PublicResolver returns: `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`
   - Malicious resolver returns: `0x0000000000000000000000000000000000001337`
   - Result: Funds diverted to attacker

### Interface Behavior

- **Typing Phase**: Shows correct address from PublicResolver
- **Sending Phase**: Uses actual resolver (which may be malicious)
- **Warning System**: Detects address mismatch and alerts user
- **Visual Feedback**: Color-coded indicators for safe vs malicious addresses

## Mitigation Strategies

### For Users

1. **Always Verify Resolver**: Check which resolver is set for a name before sending funds
2. **Compare Addresses**: If DApp shows address, verify it matches PublicResolver
3. **Use Trusted DApps**: Only use DApps that verify resolver addresses
4. **Manual Verification**: For large transactions, manually verify addresses

### For DApp Developers

1. **Always Query PublicResolver**: For verification, always use PublicResolver directly
2. **Warn on Non-PublicResolver**: Alert users when name uses non-PublicResolver
3. **Show Resolver Address**: Display which resolver will be used for transaction
4. **Address Comparison**: Compare PublicResolver address with actual resolver address
5. **User Confirmation**: Require explicit confirmation when addresses don't match

### For ENS Protocol

1. **Resolver Verification**: Consider implementing resolver reputation system
2. **Warning System**: Alert users when resolver changes
3. **Default Resolver**: Encourage use of PublicResolver as default
4. **Transaction Verification**: Consider adding resolver verification to transaction flow

## Contract Architecture and Functionality

### MaliciousResolver Contract

The `MaliciousResolver` contract, located at `contracts/MaliciousResolver.sol`, is a malicious ENS resolver that performs man-in-the-middle attacks by intercepting address resolution requests and returning attacker-controlled addresses instead of correct ones. The contract implements the standard ENS resolver interfaces, making it compatible with the ENS ecosystem while secretly redirecting funds.

The constructor takes three parameters: an attacker address where funds will be redirected, an optional ENS registry address (defaults to mainnet), and an optional PublicResolver address (defaults to mainnet). The attacker address is immutable and cannot be changed after deployment, ensuring the attack vector remains consistent. The contract stores references to both the ENS registry and the legitimate PublicResolver, which it uses for obfuscation purposes.

The core attack function is `addr(bytes32 node)`, which implements the man-in-the-middle attack. When called, it first queries the legitimate PublicResolver to retrieve the correct address for the given ENS node. This step serves two purposes: it makes the malicious resolver appear legitimate to anyone monitoring the contract's behavior, and it allows the attacker to know what address should be returned, enabling sophisticated obfuscation techniques. After retrieving the correct address, the function stores it internally for tracking purposes (in the non-view version) and then returns the attacker's address instead of the correct one. This means that when a user or DApp queries the resolver, they receive the attacker's address while believing they're getting the legitimate address for the ENS name.

The contract also implements a reverse resolution attack through the `name(bytes32 node)` function. This function returns arbitrary names for reverse resolution queries, where an address is resolved back to an ENS name. This enables impersonation attacks, as the malicious resolver can return names like "vitalik.eth" for any address, making it appear that a transaction is coming from a trusted source when it's actually from an attacker.

The contract includes several tracking functions that allow the attacker to monitor the attack's effectiveness. The `addrWithTracking()` function is a non-view version of `addr()` that stores intercepted addresses in a mapping, allowing the attacker to see what addresses were supposed to be returned. The `getInterceptedAddress()` and `getInterceptionCount()` functions provide read access to this tracking data, showing which addresses were intercepted and how many times each node was queried.

To maintain compatibility with the ENS ecosystem and avoid detection, the contract implements several obfuscation features. It queries the PublicResolver internally to make its behavior appear legitimate, emits events that make transaction logs look normal, supports ERC165 interface detection so it can be identified as a valid resolver, and implements `multicallWithNodeCheck()` for compatibility with ENS operations that require multicall functionality.

The attack mechanism works as follows: when a user or DApp calls the resolver's `addr()` function with an ENS node, the malicious resolver intercepts the call, queries the PublicResolver to get the correct address, stores it for tracking purposes, and then returns the attacker's address instead. The user receives the attacker's address but believes they're getting the correct address, leading them to send funds to the attacker instead of the intended recipient.

### MaliciousResolverAdvanced Contract

The `MaliciousResolverAdvanced` contract, located at `contracts/MaliciousResolverAdvanced.sol`, is an enhanced version of the basic malicious resolver with additional features for selective targeting and more sophisticated attacks. This contract allows the attacker to target specific ENS names while appearing legitimate for others, making the attack harder to detect.

The contract implements selective targeting through three key storage variables: a mapping of malicious addresses per node, a mapping that tracks which nodes are targeted, and a boolean flag that determines whether to attack all nodes or only targeted ones. This allows the attacker to configure the resolver to only attack specific ENS names while returning correct addresses for all other names, making the malicious behavior much harder to detect through automated monitoring.

The selective targeting feature enables sophisticated multi-target attacks where different ENS names can be redirected to different attacker addresses. Each targeted node can have its own malicious address, allowing the attacker to manage multiple attack campaigns simultaneously. If a node is not specifically targeted, the contract falls back to the default attacker address, or if selective mode is enabled, it returns the correct address from PublicResolver, making it appear completely legitimate.

The contract includes enhanced obfuscation features that make the attack even more difficult to detect. It emits events that make transaction logs appear legitimate, tracks intercepted addresses per node for analysis, and can appear completely legitimate for non-targeted nodes by returning correct addresses from PublicResolver. This creates a scenario where the resolver behaves correctly for most queries, only redirecting funds for specific targeted names.

The contract operates in two distinct attack modes. In the first mode, when `attackAllNodes` is set to true, the resolver returns malicious addresses for all resolution requests, making it simple to deploy but easier to detect. In the second mode, when `attackAllNodes` is false and specific nodes are targeted using the `targetNode()` function, the resolver only attacks those specific nodes while returning correct addresses for all others. This selective targeting mode is much more sophisticated and significantly harder to detect, as the resolver appears legitimate for the vast majority of queries.

### VictimUser Contract

The `VictimUser` contract, located at `contracts/VictimUser.sol`, is a mock contract that represents a user or DApp that unknowingly sends funds through a malicious resolver. This contract demonstrates the victim's perspective and shows how normal ENS resolution flows can be exploited.

The contract includes a function called `sendFundsToENSName()` that simulates what a typical DApp would do when sending funds to an ENS name. The function takes a namehash and an expected address as parameters, then follows a standard resolution flow: it queries the ENS registry to get the resolver for the namehash, queries that resolver to get the address, and then sends funds to that address. The critical problem is that if the resolver is malicious, the funds go to the attacker instead of the intended recipient, even though the user may have verified the expected address beforehand.

A simplified version called `sendFundsToENSNameSimple()` demonstrates what most DApps actually do in practice. This function performs no verification whatsoever—it simply resolves the name to an address and sends funds to that address. This represents the most vulnerable scenario, as there's no check to ensure the resolver is legitimate or that the address matches what the user expects.

The contract also includes a security function called `verifyResolvedAddress()` that demonstrates what DApps should do to protect users. This function compares the address returned by the name's resolver with the address returned by the PublicResolver, returning a safety status and both addresses. This is the proper security practice that all DApps should implement before sending funds, as it would detect when a malicious resolver is being used.

The attack demonstration shows how the victim contract becomes vulnerable: when `sendFundsToENSName()` is called, it queries the ENS registry for the resolver, receives the MaliciousResolver address, queries that resolver for the address, receives the attacker's address, and then sends funds to that address. The funds are diverted to the attacker, and the victim has no way of knowing this happened unless they explicitly verify the resolver address beforehand.

### Contract Interactions

The normal flow for ENS resolution is straightforward: a user initiates a transaction, the transaction queries the ENS registry, the registry returns the PublicResolver address, the PublicResolver returns the correct address, and funds are sent to that correct address. This flow is safe and works as intended when legitimate resolvers are used.

The attack flow demonstrates how the malicious resolver intercepts this process. A user initiates a transaction, the transaction queries the ENS registry, but instead of returning the PublicResolver, the registry returns the MaliciousResolver address (either because it was set as the resolver for that name, or because the DApp was compromised). The MaliciousResolver internally queries the PublicResolver to get the correct address for obfuscation purposes, but then returns the attacker's address instead. The funds are sent to the attacker, and the user has no indication that anything went wrong.

The key difference between the safe and malicious flows is that in the malicious flow, the resolver address returned by the ENS registry is not the PublicResolver, but rather a malicious contract that looks legitimate but redirects funds. The malicious resolver's ability to query the PublicResolver internally makes it appear legitimate, as it's making the same queries a legitimate resolver would make, but it's returning different results.

### Interface Compliance

Both malicious resolver contracts implement the standard ENS resolver interfaces to ensure compatibility with the ENS ecosystem. They implement `IAddrResolver`, which requires the `addr(bytes32 node)` function that returns an address payable. This is the core function used for address resolution and is required for any resolver to work with ENS.

The contracts also implement `INameResolver`, which requires the `name(bytes32 node)` function that returns a string. This function is used for reverse resolution, where an address is resolved back to an ENS name. The malicious resolvers can abuse this function to return arbitrary names, enabling impersonation attacks.

Both contracts support ERC165 interface detection through the `supportsInterface()` function, which allows other contracts to verify that these contracts implement the expected interfaces. This makes the malicious resolvers appear as legitimate resolver implementations when queried by interface detection mechanisms.

The contracts implement `multicallWithNodeCheck()`, which is required for some ENS operations that batch multiple resolver calls together. This function accepts an array of encoded function calls and returns an array of results. The malicious resolvers implement this function to return empty results, ensuring compatibility while not interfering with the attack mechanism.

### Storage and State

The `MaliciousResolver` contract maintains several state variables to support its attack functionality. The `attacker` variable stores the immutable address where funds will be redirected, ensuring consistency throughout the contract's lifetime. The `reverseNames` mapping stores custom names for reverse resolution attacks, allowing the attacker to return arbitrary names for specific addresses. The `interceptedAddresses` mapping tracks what addresses were intercepted for each node, and the `interceptionCount` mapping counts how many times each node was queried, providing analytics for the attacker.

The `MaliciousResolverAdvanced` contract extends this storage with additional variables for selective targeting. The `defaultAttacker` variable stores the default malicious address used when no specific address is set for a node. The `maliciousAddresses` mapping allows different malicious addresses to be set for different nodes, enabling sophisticated multi-target attacks. The `isTargeted` mapping tracks which nodes are specifically targeted for attacks, and the `attackAllNodes` boolean flag determines whether to attack all nodes or only targeted ones. The `maliciousReverseNames` mapping stores custom malicious names for reverse resolution, allowing different impersonation strategies for different addresses.

### Security Considerations

This attack works because the ENS protocol does not verify resolver legitimacy. The ENS registry simply stores which resolver contract is set for each name, but it doesn't verify that the resolver is trustworthy or that it returns correct addresses. Resolvers are free to return any address they want, and there's no built-in mechanism to detect or prevent malicious behavior.

The attack is particularly difficult to detect because the malicious resolver queries the PublicResolver internally, making it appear legitimate. When someone monitors the contract's behavior, they see it making the same queries a legitimate resolver would make, but they don't see that it's returning different results. The malicious resolver returns valid Ethereum addresses, so there are no obvious errors or reverts that would alert users to the attack. The attack works transparently in the normal transaction flow, making it nearly invisible to users who don't explicitly verify resolver addresses.

The fundamental security issue is that users and DApps trust the resolver address returned by the ENS registry without verification. There's no built-in mechanism to compare the resolver's output with the PublicResolver's output, and most DApps don't implement this verification themselves. This creates a trust gap where users verify addresses but don't verify that the resolver used for the transaction matches the resolver used for verification, allowing the attack to succeed even when users take precautions.

## Code Artifacts

### Contracts

- `contracts/MaliciousResolver.sol` - Basic malicious resolver implementation
- `contracts/MaliciousResolverAdvanced.sol` - Advanced version with selective targeting
- `contracts/VictimUser.sol` - Mock contract demonstrating victim's perspective
- `test/DeployMaliciousResolverTest.t.sol` - Foundry test for deployment
- `test/VictimUserTest.t.sol` - Test demonstrating fund redirection

### Interface

- `ui/index.html` - Web-based demonstration interface
- `ui/README.md` - Interface documentation

### Documentation

- `decomposition/MAN_IN_THE_MIDDLE_ATTACK.md` - Detailed attack explanation
- `decomposition/REVERSE_RESOLUTION_AND_DAPP_ATTACKS.md` - Additional attack vectors
- `contracts/README_MALICIOUS_RESOLVER.md` - Contract documentation

## Testing

### Local Fork Testing

Tests were run on a local mainnet fork using Foundry:

```bash
forge test --fork-url $RPC_URL --match-test testManInTheMiddleAttack -vv
```

**Results**:
- Malicious resolver successfully deployed
- Address interception confirmed
- Fund redirection demonstrated
- Warning system functional

### Interface Testing

The web interface was tested with:
- Real ENS names (accessor.eth, vitalik.eth)
- Real PublicResolver queries
- Malicious resolver simulation
- Address comparison functionality

## Recommendations

### Immediate Actions

1. **User Education**: Inform users about resolver verification
2. **DApp Updates**: Update DApps to verify resolver addresses
3. **Warning Systems**: Implement resolver change notifications
4. **Best Practices**: Document resolver verification procedures

### Long-term Solutions

1. **Protocol Improvements**: Consider resolver reputation/verification system
2. **Standard Interfaces**: Develop standard interfaces for resolver verification
3. **Monitoring**: Implement monitoring for resolver changes
4. **User Tools**: Develop browser extensions or tools for resolver verification

## Conclusion

The malicious resolver attack represents a significant threat to ENS users. The attack is particularly dangerous because:

1. Users can verify the correct address but still be attacked
2. The attack is transparent and doesn't require user interaction beyond normal transaction flow
3. The attack can be automated and scaled
4. Detection requires explicit verification steps

Our demonstration interface successfully shows how this attack works and provides a tool for:
- Security researchers to understand the attack
- DApp developers to test their mitigation strategies
- Users to understand the importance of resolver verification

The key takeaway is that **verifying an address is not enough** - users must also verify that the resolver used for the transaction matches the resolver used for verification.

## References

- ENS Documentation: https://docs.ens.domains/
- PublicResolver Contract: `0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41`
- ENS Registry: `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`
- Malicious Resolver Contract: See `contracts/MaliciousResolver.sol`
- Demonstration Interface: See `ui/index.html`

---

**Report Generated**: December 2024
**Author**: Security Research Team
**Status**: Active Research
**Severity**: High
