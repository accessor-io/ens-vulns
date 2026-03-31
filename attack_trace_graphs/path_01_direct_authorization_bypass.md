# PATH 1: DIRECT AUTHORIZATION BYPASS THROUGH MSG.SENDER PRESERVATION

## Attack Vector Overview
The delegatecall vulnerability allows attackers to bypass authorization checks by preserving the original caller's msg.sender context while executing functions with the contract's storage permissions.

## State Transition Diagram

```
[Attacker Contract]
       |
       | multicall(maliciousData)
       v
[Multicallable.multicall()]
       |
       | for each data[i] in batch:
       |   address(this).delegatecall(data[i])
       v
[Individual Function Execution]
       |
       | msg.sender = attacker (PRESERVED)
       | storage = resolver contract (DELEGATED)
       v
[isAuthorised(node) Check]
       |
       | 1. msg.sender == trustedETHController? → false
       | 2. ens.owner(node) == msg.sender? → check ownership
       | 3. operator/approval checks
       v
[Authorization Result]
       |
       | If attacker controls node → ALLOWED
       | If attacker has approvals → ALLOWED
       | Else → DENIED (but storage accessible via other paths)
```

## Function Call Trace

### Initial Entry Point
```
Function: multicall(bytes[] calldata data)
Caller: Attacker
Context: msg.sender = attacker, storage = attacker_contract
```

### Delegatecall Execution
```
Function: address(this).delegatecall(data[i])
Target: PublicResolver contract
Context: msg.sender = attacker (PRESERVED), storage = resolver (DELEGATED)
Executed Code: Resolver functions (setAddr, setText, etc.)
```

### Authorization Check
```
Function: isAuthorised(bytes32 node)
Context: msg.sender = attacker, storage = resolver
Logic:
├── trustedETHController check → false (attacker != controller)
├── ens.owner(node) check → depends on node ownership
├── operator approvals check → depends on _operatorApprovals mapping
└── token approvals check → depends on _tokenApprovals mapping
```

## State Change Analysis

### Storage Modifications Possible
- `versionable_addresses[version][node][coinType]` ← attacker data
- `versionable_texts[version][node][key]` ← attacker data
- `versionable_pubkeys[version][node]` ← attacker data
- `recordVersions[node]` ← incremented (if clearRecords called)
- `_operatorApprovals[attacker][*]` ← manipulated
- `_tokenApprovals[attacker][node][*]` ← manipulated

### State Transitions
```
Initial State: Contract has legitimate resolver records
    ↓
Multicall Entry: msg.sender preserved, storage context gained
    ↓
Function Execution: Individual resolver functions called with elevated privileges
    ↓
Authorization Bypass: isAuthorised() sees attacker's msg.sender but resolver storage
    ↓
State Modification: Attacker data written to resolver mappings
    ↓
Final State: Contract contains attacker-controlled records
```

## Prerequisites and Conditions
- Multicall function is publicly accessible
- Attacker can encode valid function calls in multicall data
- Node ownership or approval rights (or authorization bypass via other vectors)

## Impact Assessment
- **Authorization Bypass**: Functions execute with contract's authorization level
- **Storage Pollution**: Legitimate records mixed with attacker data
- **Trust Erosion**: ENS resolutions become unreliable
- **Economic Damage**: Users send funds to wrong addresses

## Sub-path Exploitation

### 1.1 Trusted Controller Impersonation
**When**: Attacker has no special privileges
**Result**: Authorization fails at controller check, falls back to ownership checks

### 1.2 Operator Privilege Escalation
**When**: Attacker can set operator approvals
**Result**: Future calls see attacker as approved operator

### 1.3 Delegate Token Approval Abuse
**When**: Attacker can set token-specific approvals
**Result**: Node-specific authorization bypass established