# PATH 18: SELFDESTRUCT IN DELEGATE CONTEXT

## Attack Vector Overview
Delegatecall can execute selfdestruct with the contract's privileges, destroying the resolver contract and potentially draining any ETH it holds.

## State Transition Diagram

```
[Multicall Entry]
       |
       | multicall(selfdestructPayload)
       v
[Delegatecall Execution]
       |
       | address(this).delegatecall(selfdestructCode)
       v
[Assembly Execution]
       |
       | selfdestruct(attackerAddress)
       v
[Contract Self-Destruction]
       |
       +-------------------+
       |                   |
       v                   v
[ETH Transfer]         [Code Deletion]
       |                   |
       | balance sent      | bytecode = 0x
       v                   | nonce unchanged
[Funds to Attacker]    | storage persists?
       |                   |
       +-------------------+
       |                   |
       v                   v
[Protocol Failure]     [Permanent Damage]
```

## Function Call Trace

### Selfdestruct Payload Construction
```
multicall([
    abi.encode(assembly {
        // Selfdestruct with attacker as beneficiary
        let beneficiary := attackerAddress
        selfdestruct(beneficiary)
    })
])
```

### Delegatecall Context
```
Function: address(this).delegatecall(selfdestructCode)
├── Target: PublicResolver contract
├── Context: msg.sender = attacker, storage = resolver
├── Execution: selfdestruct(attackerAddress)
└── Result: Contract destroys itself
```

### Selfdestruct Execution Details
```
Selfdestruct Operation:
├── Check: contract.balance > 0
├── Transfer: SENDALL contract.balance to attackerAddress
├── Code: DELETE contract bytecode (set to empty)
├── Storage: PERSIST (selfdestruct doesn't clear storage in newer EVM)
└── Events: No events emitted
```

## State Change Analysis

### Pre-Selfdestruct State
```
PublicResolver Contract:
├── bytecode: Valid resolver implementation
├── balance: X ETH (from failed transfers, etc.)
├── storage: All resolver mappings intact
└── nonce: Current transaction nonce
```

### Post-Selfdestruct State
```
Destroyed Contract:
├── bytecode: 0x (empty)
├── balance: 0 ETH (sent to attacker)
├── storage: CLEARED (EIP-6780: storage wiped on selfdestruct)
└── nonce: Unchanged
```

### State Transition Path
```
Active Contract State
       ↓
Multicall Entry
       ↓
Delegatecall Execution
       ↓
Selfdestruct Call
       ↓
ETH Transfer to Attacker
       ↓
Bytecode Deletion
       ↓
Storage Wipe (EIP-6780)
       ↓
Dead Contract State
```

## Prerequisites and Conditions
- Contract must hold ETH balance (>0)
- Delegatecall must allow selfdestruct execution
- Attacker must encode valid selfdestruct bytecode
- EVM must execute selfdestruct (not reverted)

## Impact Assessment
- **Contract Destruction**: Resolver becomes permanently unusable
- **Fund Theft**: Any ETH held by contract stolen
- **Protocol Failure**: ENS resolutions break for destroyed resolver
- **Chain Reaction**: May affect dependent contracts

## Sub-path Exploitation

### 18.1 Contract Destruction with Fund Theft
```
Attack Sequence:
├── Check contract.balance > 0
├── Execute selfdestruct(attacker)
└── Result: Contract destroyed + ETH stolen
```

### 18.2 Selective Asset Draining
```
Conditional Attack:
├── if balance > threshold → selfdestruct
├── else → normal operation
└── Result: Targeted fund extraction
```

### 18.3 Protocol-Wide Destruction
```
Cascading Failure:
├── Destroy PublicResolver
├── ENS resolutions fail
├── Dependent dApps break
└── Economic damage cascades
```

## EVM-Specific Considerations

### Selfdestruct Behavior (Post-EIP-6780)
```
Pre-EIP-6780: Storage persists after selfdestruct
Post-EIP-6780: Storage wiped, contract completely destroyed

Impact on Attack:
├── Storage mappings cleared
├── No forensic evidence remains
├── Complete contract annihilation
└── Recovery impossible
```

### Gas Considerations
```
Selfdestruct Gas Cost:
├── Base cost: 5,000 gas
├── Data copying: Variable
├── Balance transfer: 9,000 gas
└── Total: ~14,000 gas (cheap to execute)
```

## Detection and Prevention
**Stealthy Attack**:
- No events emitted during selfdestruct
- Contract appears to "disappear" from blockchain
- ETH transfer may be only visible indicator
- Storage wipe erases all evidence

**Prevention**: Selfdestruct must be blocked in delegatecall context.

## Broader Implications
**ENS Ecosystem Impact**:
- Primary resolver destroyed → mass resolution failures
- Users cannot resolve names → dApps break
- Economic activity halts → protocol value destroyed
- Recovery requires new resolver deployment → trust lost

**This attack vector enables complete protocol destruction** through a single malicious multicall.