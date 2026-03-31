# PATH 26: SELFDESTRUCT WITH ETH DRAIN

## Attack Vector Overview
Using selfdestruct to destroy the contract while draining any accumulated ETH balance to the attacker.

## State Transition Diagram

```
[Contract with ETH Balance]
       |
       | address(this).balance > 0
       v
[Multicall Selfdestruct]
       |
       | delegatecall(selfdestruct(attacker))
       v
[Selfdestruct Execution]
       |
       +-------------------+
       |                   |
       v                   v
[ETH Transfer]           [Contract Destruction]
       |                   |
       | balance → attacker| bytecode = 0x
       v                   | nonce unchanged
[Funds Stolen]           [Contract Dead]
       |                   |
       +-------------------+
       |                   |
       v                   v
[Economic Gain]          [Protocol Failure]
```

## Function Call Trace

### Selfdestruct with Fund Theft
```
Balance Check and Destruction:
├── Check: address(this).balance > 0
├── Execute: selfdestruct(attackerAddress)
├── Transfer: All ETH sent to attacker
└── Contract permanently destroyed

Conditional Destruction:
├── Only destroy if balance > threshold
├── Avoid destroying empty contracts
└── Maximize economic gain
```

## State Change Analysis

### Irrecoverable Contract Destruction
```
Pre-Destruction State:
├── bytecode: Functional resolver contract
├── balance: Accumulated ETH from failed txs
├── storage: All resolver mappings intact
└── operational: Contract fully functional

Post-Destruction State:
├── bytecode: 0x (empty)
├── balance: 0 ETH (sent to attacker)
├── storage: Wiped (EIP-6780)
└── operational: Permanently dead

Economic Impact:
├── Attacker gains: Contract balance
├── ENS users lose: Name resolution capability
├── Protocol loses: Critical infrastructure
└── Recovery cost: Redeploy entire resolver
```

## Prerequisites and Conditions
- Contract holds ETH balance
- Selfdestruct executable via delegatecall
- Attacker can encode selfdestruct bytecode
- Contract not immutable (can be destroyed)

## Impact Assessment
- **Fund Theft**: All contract ETH stolen
- **Contract Destruction**: Permanent loss of functionality
- **Protocol Disruption**: ENS resolution breaks
- **Recovery Required**: Expensive contract redeployment

## Sub-path Exploitation

### 26.1 Contract Destruction with Fund Theft
**Mechanism**: Destroy contract while stealing accumulated ETH
**Impact**: Economic gain + permanent protocol damage

### 26.2 Selective Asset Draining
**Mechanism**: Only destroy contracts with significant balances
**Impact**: Targeted fund extraction without unnecessary damage

### 26.3 Protocol-Wide Destruction
**Mechanism**: Destroy multiple critical contracts
**Impact**: Complete ENS ecosystem failure