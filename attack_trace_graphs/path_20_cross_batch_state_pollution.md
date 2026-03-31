# PATH 20: CROSS-BATCH STATE POLLUTION

## Attack Vector Overview
State changes from one multicall batch affecting future batches, creating persistent pollution that enables increasingly sophisticated attacks.

## State Transition Diagram

```
[Initial Clean State]
       |
       | Contract properly configured
       v
[Batch 1: Backdoor Setup]
       |
       | multicall(setupApprovals)
       v
[Persistent State Change]
       |
       +-------------------+
       |                   |
       v                   v
[Operator Grants]        [Delegation Setup]
       |                   |
       | _operatorApprovals| _tokenApprovals
       v                   | modified
[Access Granted]         [Rights Established]
       |                   |
       +-------------------+
       |                   |
       v                   v
[Batch 2: Exploitation]  [Batch 3: Escalation]
       |                   |
       | Uses granted      | Uses Batch 2 results
       v                   | for more access
[Further Compromise]     [Attack Amplification]
       |
       +-------------------+
       |                   |
       v                   v
[Self-Perpetuating]      [Exponential Growth]
       |                   |
       | Each batch enables| Attack surface grows
       | more attacks      | with each batch
       v                   v
[Total Domination]       [Irrecoverable State]
```

## Function Call Trace

### Multi-Batch Attack Chain
```
Batch 1 - Setup Phase:
├── multicall([setApprovalForAll(attacker, true)])
├── _operatorApprovals[attacker][attacker] = true
└── Persistent backdoor established

Batch 2 - Exploitation Phase:
├── multicall([setAddr(node1, attackerAddr)]) [using operator rights]
├── Node hijacked due to granted approvals
└── Further access rights established

Batch 3 - Escalation Phase:
├── multicall([setResolver(node2, attackerResolver)]) [using node1 rights]
├── Additional nodes compromised
└── Attack surface exponentially increased
```

### State Pollution Persistence
```
Cross-Transaction Effects:
├── Batch 1 changes survive to Batch 2
├── Batch 2 changes enable Batch 3
├── Each batch builds on previous success
└── Self-amplifying attack chain

Pollution Accumulation:
├── Initial: Clean contract state
├── After Batch 1: Operator backdoors
├── After Batch 2: Node hijacking + more approvals
├── After Batch 3: Multiple nodes + escalated privileges
└── Final: Complete contract domination
```

## State Change Analysis

### Progressive State Corruption
```
State Evolution:
├── T=0: _operatorApprovals = {}, _tokenApprovals = {}
├── T=1: _operatorApprovals[attacker][attacker] = true
├── T=2: versionable_addresses[node1] = attackerAddr + more approvals
├── T=3: Multiple nodes hijacked + upgrade contract controlled
└── T=N: Complete protocol compromise

Pollution Characteristics:
├── Changes persist across transactions
├── Each change enables more changes
├── Recovery becomes exponentially harder
└── Attack becomes self-sustaining
```

### Pollution Feedback Loops
```
Positive Feedback:
├── More approvals → More access → More approvals
├── More nodes controlled → More influence → More nodes
├── More contracts compromised → More tools → More compromise
└── Exponential attack growth

State Inertia:
├── Clean state: Hard to compromise initially
├── Polluted state: Easy to compromise further
├── Recovery: Requires cleaning all pollution sources
└── Prevention: Impossible once pollution starts
```

## Prerequisites and Conditions
- State changes persist across transactions
- Contract has delegation/approval mechanisms
- Multiple multicall batches can be executed
- No state cleaning between operations

## Impact Assessment
- **Self-Amplifying Attacks**: Each success enables more attacks
- **Persistent Pollution**: State changes survive transaction boundaries
- **Exponential Compromise**: Attack surface grows with each batch
- **Recovery Impossibility**: Pollution sources multiply beyond control

## Sub-path Exploitation

### 20.1 Authorization Persistence
**Mechanism**: Granted approvals survive and enable future attacks
**Impact**: Permanent access without repeated exploitation

### 20.2 State Machine Abuse
**Mechanism**: State changes break contract logic flow permanently
**Impact**: Contract enters invalid state with no recovery

### 20.3 Pollution Cascades
**Mechanism**: Each compromise enables more compromises
**Impact**: Total domination through exponential growth