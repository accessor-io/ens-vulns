# PATH 3: TRUSTED CONTROLLER PRIVILEGE ESCALATION

## Attack Vector Overview
When trusted controllers (EthRegistrarController, ReverseRegistrar) call multicallWithNodeCheck(), the delegatecall inherits their elevated privileges, enabling complete contract compromise.

## State Transition Diagram

```
[Trusted Controller Call]
       |
       | multicallWithNodeCheck(node, maliciousData)
       v
[Multicallable.multicallWithNodeCheck()]
       |
       | Nodehash validation: txNamehash == node ✓
       | delegatecall to address(this) with data[i]
       v
[Delegatecall Execution]
       |
       | msg.sender = TrustedController (PRESERVED)
       | storage = resolver contract (DELEGATED)
       v
[isAuthorised(node) Check]
       |
       | msg.sender == trustedETHController? → TRUE ✓
       | IMMEDIATE RETURN: authorized = true
       v
[Complete Authorization Bypass]
       |
       | ANY function executes with FULL privileges
       | NO ownership/approval checks performed
       v
[Arbitrary State Modification]
```

## Function Call Trace

### Trusted Controller Entry
```
Function: EthRegistrarController.register()
├── Context: msg.sender = user, storage = controller
├── Logic: Validates commitment, processes payment
└── Action: Calls resolver.multicallWithNodeCheck() during registration
```

### Multicall Execution
```
Function: multicallWithNodeCheck(bytes32 nodehash, bytes[] data)
├── Context: msg.sender = EthRegistrarController, storage = resolver
├── Validation: Each data[i] must have matching nodehash
├── Execution: address(this).delegatecall(data[i]) for each call
└── Context Preservation: msg.sender remains EthRegistrarController
```

### Privileged Function Execution
```
Individual Function Calls (e.g., setAddr, setText, etc.)
├── Context: msg.sender = EthRegistrarController (trusted)
├── Authorization: isAuthorised() → returns true immediately
├── No Checks: Ownership, approvals completely bypassed
└── Execution: Any resolver function runs with full access
```

## State Change Analysis

### Privilege Escalation Flow
```
Normal Call:
├── msg.sender = user
├── isAuthorised() → false (user != trusted controller)
└── Function fails

Trusted Controller Call:
├── msg.sender = EthRegistrarController
├── isAuthorised() → true (controller is trusted)
└── Function succeeds with full privileges
```

### Storage Impact Through Trusted Context
```
Target Storage Modifications:
├── versionable_addresses[*][*][*] ← Any data writable
├── versionable_texts[*][*][*] ← Any data writable
├── versionable_pubkeys[*][*] ← Any data writable
├── versionable_abis[*][*][*] ← Any data writable
├── _operatorApprovals[*][*] ← Any approvals settable
├── _tokenApprovals[*][*][*] ← Any delegations settable
└── recordVersions[*] ← Any version manipulation
```

### State Invariants Destroyed
- **Trust Model**: Trusted controllers can be subverted
- **Authorization Model**: All access controls become meaningless
- **Consistency Model**: Any data can be written to any node
- **Auditability**: Changes appear to come from legitimate source

## Prerequisites and Conditions
- Trusted controller must call multicallWithNodeCheck() during normal operation
- Nodehash validation must pass (attacker must match expected node)
- Malicious data must be injected into the multicall batch
- Delegatecall must preserve the trusted controller's msg.sender

## Impact Assessment
- **Total Resolver Compromise**: Complete control over all ENS records
- **Protocol-Level Attack**: Affects entire ENS ecosystem
- **Trusted System Breach**: Most critical security assumption violated
- **Irreversible Damage**: Trust in ENS fundamentally destroyed

## Sub-path Exploitation

### 3.1 EthRegistrarController Exploitation
```
Registration Flow Hijacking:
├── User calls register() with valid commitment
├── Controller validates and processes payment
├── Controller calls resolver.multicallWithNodeCheck()
├── Attacker data injected into multicall batch
└── Result: Registration succeeds + resolver compromised
```

### 3.2 Reverse Registrar Exploitation
```
Reverse Setup Hijacking:
├── User sets reverse record
├── ReverseRegistrar calls multicallWithNodeCheck()
├── Attacker injects malicious resolver calls
└── Result: Reverse record set + arbitrary resolver compromise
```

### 3.3 Cross-Contract Call Exploitation
```
Third-party Integration Exploitation:
├── DeFi protocol integrates with ENS
├── Protocol calls controller functions
├── Controller calls resolver multicall
├── Attacker compromises through integration
└── Result: DeFi protocol + ENS both compromised
```

## Mitigation Difficulty
**This attack vector is nearly impossible to prevent** because:
- Trusted controllers legitimately need elevated privileges
- Multicall is a valid optimization for batch operations
- Nodehash validation seems secure but insufficient
- Delegatecall context preservation is inherent to the mechanism

**Required**: Complete redesign of privilege model or elimination of multicall in trusted contexts.