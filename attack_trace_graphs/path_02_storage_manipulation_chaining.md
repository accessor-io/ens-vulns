# PATH 2: STORAGE MANIPULATION THROUGH FUNCTION CHAINING

## Attack Vector Overview
Attackers can chain multiple function calls in a single multicall batch to manipulate contract storage in sequence, creating complex state transitions that bypass individual function authorization checks.

## State Transition Diagram

```
[Initial Contract State]
       |
       | multicall([call1, call2, call3, ...])
       v
[Batch Execution Begins]
       |
       +-------------------+
       |                   |
       v                   v
[Function 1]        [Storage State 1]
       |                   |
       | delegatecall      | SSTORE operations
       v                   v
[State Change 1] ←→ [Storage State 2]
       |                   |
       +-------------------+
       |                   |
       v                   v
[Function 2]        [Storage State 2]
       |                   |
       | delegatecall      | SSTORE operations
       v                   v
[State Change 2] ←→ [Storage State 3]
       |                   |
       +-------------------+
       |                   |
       v                   v
[Final Function]     [Final Storage State]
```

## Function Call Trace

### Multicall Batch Structure
```
multicall([
    abi.encodeCall(setApprovalForAll, (attacker, true)),     // Function 1
    abi.encodeCall(approve, (targetNode, attacker, true)),   // Function 2
    abi.encodeCall(setAddr, (targetNode, attackerAddr)),     // Function 3
    abi.encodeCall(clearRecords, (targetNode))              // Function 4
])
```

### Sequential Execution Flow
```
Call 1: setApprovalForAll(attacker, true)
├── Context: msg.sender = attacker, storage = resolver
├── Authorization: setApprovalForAll has no node-specific checks
├── State Change: _operatorApprovals[attacker][attacker] = true
└── Result: Attacker becomes operator for themselves

Call 2: approve(targetNode, attacker, true)
├── Context: msg.sender = attacker, storage = resolver (unchanged)
├── Authorization: setApprovalForAll allows this
├── State Change: _tokenApprovals[attacker][targetNode][attacker] = true
└── Result: Attacker gets token-specific approval

Call 3: setAddr(targetNode, attackerAddr)
├── Context: msg.sender = attacker, storage = resolver (modified)
├── Authorization: isApprovedFor() returns true due to token approval
├── State Change: versionable_addresses[version][targetNode][ETH] = attackerAddr
└── Result: Target node now resolves to attacker address

Call 4: clearRecords(targetNode)
├── Context: msg.sender = attacker, storage = resolver (further modified)
├── Authorization: Token approval still valid
├── State Change: recordVersions[targetNode]++
└── Result: Previous records become inaccessible
```

## State Change Analysis

### Storage Slot Evolution
```
Initial Storage:
├── _operatorApprovals[attacker][attacker] = false
├── _tokenApprovals[attacker][targetNode][attacker] = false
├── versionable_addresses[version][targetNode][ETH] = legitimateAddr
└── recordVersions[targetNode] = 0

After Call 1:
├── _operatorApprovals[attacker][attacker] = true ← MODIFIED
├── _tokenApprovals[attacker][targetNode][attacker] = false
├── versionable_addresses[version][targetNode][ETH] = legitimateAddr
└── recordVersions[targetNode] = 0

After Call 2:
├── _operatorApprovals[attacker][attacker] = true
├── _tokenApprovals[attacker][targetNode][attacker] = true ← MODIFIED
├── versionable_addresses[version][targetNode][ETH] = legitimateAddr
└── recordVersions[targetNode] = 0

After Call 3:
├── _operatorApprovals[attacker][attacker] = true
├── _tokenApprovals[attacker][targetNode][attacker] = true
├── versionable_addresses[version][targetNode][ETH] = attackerAddr ← MODIFIED
└── recordVersions[targetNode] = 0

After Call 4:
├── _operatorApprovals[attacker][attacker] = true
├── _tokenApprovals[attacker][targetNode][attacker] = true
├── versionable_addresses[version+1][targetNode][ETH] = attackerAddr
└── recordVersions[targetNode] = 1 ← MODIFIED (old data inaccessible)
```

### State Invariants Broken
- **Ownership Invariant**: Records can be modified without ownership
- **Approval Invariant**: Approvals can be self-granted
- **Version Invariant**: Record versions can be manipulated arbitrarily
- **Consistency Invariant**: Storage state becomes internally inconsistent

## Prerequisites and Conditions
- Multicall batch execution preserves storage context between calls
- Functions can modify storage that affects subsequent authorization checks
- No state validation between individual function calls
- Delegatecall preserves attacker msg.sender throughout batch

## Impact Assessment
- **Complex State Corruption**: Multiple storage slots manipulated in sequence
- **Authorization Evasion**: Later calls benefit from state changes by earlier calls
- **Forensic Evasion**: clearRecords() can erase attack evidence
- **Persistent Compromise**: Self-granted approvals survive the transaction

## Sub-path Exploitation

### 2.1 Record Version Manipulation
**Mechanism**: clearRecords() increments version, making old data inaccessible
**Impact**: Attack evidence hidden, new attacker data becomes canonical

### 2.2 Approval Mapping Poisoning
**Mechanism**: Self-grant operator and token approvals
**Impact**: Persistent backdoors for future attacks

### 2.3 Cross-Node Authorization Transfer
**Mechanism**: Use approved node to bootstrap attacks on other nodes
**Impact**: Single compromise enables multi-node takeover