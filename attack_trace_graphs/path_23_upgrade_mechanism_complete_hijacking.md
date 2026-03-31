# PATH 23: UPGRADE MECHANISM COMPLETE HIJACKING

## Attack Vector Overview
NameWrapper's upgrade system can be completely hijacked through multicall.

## State Transition Diagram
```
[Upgrade Hijack]
       |
       | multicall(upgradeManipulation)
       v
[setUpgradeContract(attacker)]
       |
       | upgradeContract = attackerContract
       v
[Approval Grants]
       |
       | registrar.setApprovalForAll(attacker, true)
       | ens.setApprovalForAll(attacker, true)
       v
[Upgrade Execution]
       |
       | upgrade(name, extraData)
       v
[Contract Replacement]
       |
       +-------------------+
       |                   |
       v                   v
[State Migration]      [Control Transfer]
       |                   |
       | To malicious      | Attacker controls
       v                   | all future upgrades
[Malicious Contract]   [Permanent Hijack]
```

## Function Call Trace
Upgrade Hijacking:
├── setUpgradeContract(attackerContract)
├── Grant approvals to attacker
├── Execute upgrade(name, maliciousData)
└── State migrates to attacker control

Migration Process:
├── _burn(uint256(node)) - destroy old token
├── upgradeContract.wrapFromUpgrade() - create new
├── State transferred to malicious contract
└── Original contract loses control

## State Change Analysis
Pre-Upgrade State:
├── upgradeContract = legitimateContract
├── _nameWrapperApprovals = controlled
├── Token ownership intact

Post-Upgrade State:
├── upgradeContract = attackerContract
├── _nameWrapperApprovals = attacker
├── Tokens under attacker control
├── Migration data corrupted

## Prerequisites and Conditions
- Access to setUpgradeContract function
- NameWrapper integration
- Upgrade contract deployment

## Impact Assessment
- **Complete Hijack**: All future upgrades controlled
- **State Theft**: Token ownership transferred
- **Protocol Control**: ENS upgrade mechanism compromised

## Sub-path Exploitation
### 23.1 Upgrade Contract Replacement
### 23.2 Upgrade Execution During Wrap/Unwrap
### 23.3 Upgrade State Poisoning
