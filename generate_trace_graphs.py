#!/usr/bin/env python3
"""
Batch generator for attack trace state graphs
"""

import os

# Template for trace graphs
TRACE_TEMPLATE = """# PATH {path_num}: {title}

## Attack Vector Overview
{overview}

## State Transition Diagram
```
{diagram}
```

## Function Call Trace
{call_trace}

## State Change Analysis
{state_analysis}

## Prerequisites and Conditions
{prerequisites}

## Impact Assessment
{impact}

## Sub-path Exploitation
{sub_paths}
"""

# Path data
paths_data = [
    {
        "num": "04",
        "title": "BATCH EXPLOITATION AMPLIFICATION",
        "overview": "Single multicall transaction can execute hundreds of malicious operations, enabling mass compromise at scale.",
        "diagram": """[Mass Attack Setup]
       |
       | multicall([op1, op2, ..., op100])
       v
[Batch Processing Loop]
       |
       | for i in 0..99:
       |   delegatecall(data[i])
       v
[Parallel Exploitation]
       +-------+-------+-------+
       |       |       |       |
       v       v       v       v
[Node1] [Node2] [Node3] [...Node100]
   |       |       |       |
   | Hijack| Hijack| Hijack| Hijack
   v       v       v       v
[Compromised Records × 100]""",
        "call_trace": """Batch Construction:
├── Target 100 high-value ENS names
├── Encode setAddr() calls for each
├── Single multicall transaction
└── Mass resolution hijacking

Execution Flow:
├── Gas-efficient batch processing
├── Sequential delegatecall execution
├── Each call modifies different node
└── Cumulative state corruption""",
        "state_analysis": """Storage Impact:
├── 100+ address records modified
├── versionable_addresses[*][node_i][ETH] = attackerAddr
├── Minimal gas cost per operation
└── Maximum damage per transaction

State Invariants:
├── Resolution integrity destroyed
├── User trust eroded massively
├── Economic damage scaled by batch size""",
        "prerequisites": "- Large batch size support\n- Gas limits allow batch completion\n- Target selection algorithm\n- Coordinated attack planning",
        "impact": "- **Mass Hijacking**: Hundreds of names compromised simultaneously\n- **Economic Scale**: Gas-efficient mass exploitation\n- **Detection Evasion**: Single transaction hides attack scale",
        "sub_paths": "### 4.1 Mass Name Hijacking\n### 4.2 Systematic Approval Farming\n### 4.3 Record Wiping Campaign"
    },

    {
        "num": "05",
        "title": "FUNCTION SELECTOR EXPLOITATION",
        "overview": "Malformed function selectors can cause unexpected execution paths and fallback behavior.",
        "diagram": """[Malformed Selector]
       |
       | multicall(invalidSelectorData)
       v
[Delegatecall Attempt]
       |
       | address(this).delegatecall(badData)
       v
[Fallback Execution]
       |
       | No matching function selector
       v
[Unexpected Behavior]
       +-------------------+
       |                   |
       v                   v
[Fallback Function]     [Invalid Opcode]
       |                   |
       | Arbitrary logic   | Contract crash
       v                   | or undefined state
[State Corruption]      [DoS Condition]""",
        "call_trace": """Selector Manipulation:
├── Craft invalid function selector (4 bytes)
├── Encode with manipulated parameters
├── Delegatecall executes malformed data
└── Fallback or error handling triggered

Execution Variants:
├── Fallback function execution
├── Invalid opcode exceptions
├── Unexpected state transitions""",
        "state_analysis": """Fallback Impact:
├── Unintended function execution
├── State changes from error paths
├── Memory corruption from invalid data
└── Contract stability compromised

Error State:
├── require() failures with custom messages
├── revert() with attacker-controlled data
├── Exception state preservation""",
        "prerequisites": "- Knowledge of fallback function logic\n- Invalid selector generation\n- Error handling manipulation",
        "impact": "- **Unexpected Execution**: Contract behaves unpredictably\n- **State Pollution**: Error paths modify storage\n- **DoS Potential**: Contract can be crashed",
        "sub_paths": "### 5.1 Fallback Function Exploitation\n### 5.2 Interface Function Abuse"
    },

    {
        "num": "11",
        "title": "RETURN DATA MANIPULATION",
        "overview": "Delegatecall return data can be manipulated to affect subsequent calls in the batch.",
        "diagram": """[Call 1 (Success)]
       |
       | return (true, manipulatedData)
       v
[Call 2 Processing]
       |
       | Uses return data from Call 1
       v
[Data Poisoning]
       |
       +-------------------+
       |                   |
       v                   v
[Parameter Injection]   [Control Flow Hijack]
       |                   |
       | Wrong inputs      | Unexpected execution
       v                   | paths
[Logic Corruption]      [State Anomaly]""",
        "call_trace": """Return Data Chain:
├── Call 1: returns (success, attackerData)
├── Call 2: processes attackerData as input
├── Call 3: uses corrupted state from Call 2
└── Cascading corruption

Data Flow:
├── abi.encode results from Call 1
├── abi.decode in Call 2
├── Type confusion exploitation
└── Control flow manipulation""",
        "state_analysis": """Inter-call Dependencies:
├── Call 1 output → Call 2 input
├── Call 2 state → Call 3 logic
├── Cumulative corruption amplification
└── Quantum state where operations appear successful

Memory Persistence:
├── Return data persists in memory
├── Cross-call data leakage
├── State pollution between functions""",
        "prerequisites": "- Functions with return data dependencies\n- Type confusion opportunities\n- Memory layout knowledge",
        "impact": "- **Data Poisoning**: Functions receive wrong inputs\n- **Logic Corruption**: Control flow manipulated\n- **State Anomaly**: Contract in inconsistent state",
        "sub_paths": "### 11.1 Success Flag Spoofing\n### 11.2 Result Data Poisoning"
    },

    {
        "num": "16",
        "title": "EVM OPCODE EXPLOITATION",
        "overview": "Delegatecall enables execution of arbitrary EVM opcodes, including dangerous ones.",
        "diagram": """[Opcode Payload]
       |
       | multicall(opcodeAssembly)
       v
[EVM Execution]
       |
       +-------------------+
       |                   |
       v                   v
[Safe Opcodes]         [Dangerous Opcodes]
       |                   |
       | SSTORE, MSTORE    | SELFDESTRUCT, INVALID
       v                   | CREATE, CREATE2
[State Modification]   | CALL, DELEGATECALL
       |                   |
       +-------------------+
       |                   |
       v                   v
[Controlled Change]    [Catastrophic Failure]""",
        "call_trace": """Opcode Execution:
├── Assembly code in delegatecall
├── Direct EVM instruction execution
├── No Solidity safety checks
└── Raw blockchain operations

Dangerous Operations:
├── SELFDESTRUCT: Contract destruction
├── INVALID: Contract crash
├── SSTORE: Direct storage manipulation
└── CALL: External contract interaction""",
        "state_analysis": """EVM-Level Changes:
├── Storage: Direct slot manipulation
├── Code: Self-modification attempts
├── Balance: ETH transfers
└── Nonce: Transaction sequencing

Safety Bypass:
├── No access control at EVM level
├── No type checking
├── No bounds validation
└── Complete freedom of execution""",
        "prerequisites": "- Assembly programming knowledge\n- EVM opcode familiarity\n- Bytecode encoding ability",
        "impact": "- **Raw Power**: Any EVM operation executable\n- **No Limits**: Complete system compromise possible\n- **Irrecoverable**: EVM-level damage",
        "sub_paths": "### 16.1 Invalid Opcode Injection\n### 16.2 Jump Instruction Abuse"
    },

    {
        "num": "21",
        "title": "PRECOMPILE EXPLOITATION",
        "overview": "Delegatecall can invoke EVM precompiles with contract privileges.",
        "diagram": """[Precompile Call]
       |
       | delegatecall(precompileAddress, data)
       v
[Precompile Execution]
       |
       +-------------------+
       |                   |
       v                   v
[ECRECOVER (0x01)]     [SHA256 (0x02)]
       |                   |
       | Signature ops     | Hash operations
       v                   |
[RIP160 (0x03)]        |
       |                   |
       +-------------------+
       |                   |
       v                   v
[Cryptographic Operations]
       |
       | With contract's gas allocation
       v
[Unlimited Computation?]""",
        "call_trace": """Precompile Invocation:
├── Call precompile address (0x01-0x0a)
├── Provide input data
├── Execute cryptographic operation
└── Return result with contract gas

Gas Exploitation:
├── GST2-like gas token burning
├── Infinite gas through precompile loops
├── DoS through resource exhaustion""",
        "state_analysis": """Precompile Effects:
├── No storage modification (precompiles are pure)
├── Gas consumption manipulation
├── Computational resource control
└── Potential DoS vectors

Context Impact:
├── Contract gas pool drained
├── Block gas limit approached
├── Network congestion potential""",
        "prerequisites": "- Precompile address knowledge\n- Cryptographic operation understanding\n- Gas manipulation techniques",
        "impact": "- **Gas Theft**: Unlimited computation potential\n- **DoS**: Block gas exhaustion\n- **Resource Control**: Contract can drain gas reserves",
        "sub_paths": "### 21.1 Precompile Privilege Escalation\n### 21.2 Gas Token Exploitation"
    },

    {
        "num": "23",
        "title": "UPGRADE MECHANISM COMPLETE HIJACKING",
        "overview": "NameWrapper's upgrade system can be completely hijacked through multicall.",
        "diagram": """[Upgrade Hijack]
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
[Malicious Contract]   [Permanent Hijack]""",
        "call_trace": """Upgrade Hijacking:
├── setUpgradeContract(attackerContract)
├── Grant approvals to attacker
├── Execute upgrade(name, maliciousData)
└── State migrates to attacker control

Migration Process:
├── _burn(uint256(node)) - destroy old token
├── upgradeContract.wrapFromUpgrade() - create new
├── State transferred to malicious contract
└── Original contract loses control""",
        "state_analysis": """Pre-Upgrade State:
├── upgradeContract = legitimateContract
├── _nameWrapperApprovals = controlled
├── Token ownership intact

Post-Upgrade State:
├── upgradeContract = attackerContract
├── _nameWrapperApprovals = attacker
├── Tokens under attacker control
├── Migration data corrupted""",
        "prerequisites": "- Access to setUpgradeContract function\n- NameWrapper integration\n- Upgrade contract deployment",
        "impact": "- **Complete Hijack**: All future upgrades controlled\n- **State Theft**: Token ownership transferred\n- **Protocol Control**: ENS upgrade mechanism compromised",
        "sub_paths": "### 23.1 Upgrade Contract Replacement\n### 23.2 Upgrade Execution During Wrap/Unwrap\n### 23.3 Upgrade State Poisoning"
    },

    {
        "num": "30",
        "title": "COMPLETE PROTOCOL STATE CORRUPTION",
        "overview": "Combination of all attack vectors creates total protocol compromise.",
        "diagram": """[Multi-Vector Attack]
       |
       | Combine all 29 previous paths
       v
[Synchronized Exploitation]
       +-------+-------+-------+
       |       |       |       |
       v       v       v       v
[Auth] [Storage] [Gas] [Precompiles]
   |       |       |       |
   | Bypass | Direct | Drain | Abuse
   v       v       v       v
[State Corruption Cascade]
       |
       +-------------------+
       |                   |
       v                   v
[ENS Registry]         [NameWrapper]
       |                   |
       | Compromised       | Hijacked
       v                   | Upgrades
[Total Protocol Failure] ←→ [Attacker Control]
       |                   |
       +-------------------+
       |                   |
       v                   v
[User Funds]           [dApp Breakage]
       |                   |
       | Stolen            | Crashed
       v                   v
[Economic Collapse]""",
        "call_trace": """Comprehensive Attack:
├── Batch all exploitation vectors
├── Synchronize execution timing
├── Maximize damage per transaction
└── Minimize detection probability

Attack Orchestration:
├── Phase 1: Authorization bypass setup
├── Phase 2: Storage manipulation
├── Phase 3: Upgrade mechanism hijack
├── Phase 4: Self-destruction/cleanup""",
        "state_analysis": """Global State Corruption:
├── ENS Registry: All records compromised
├── NameWrapper: Upgrade control lost
├── PublicResolver: Storage destroyed
├── User Contracts: Funds redirected

Irrecoverable Damage:
├── Trust destroyed permanently
├── Economic value evaporated
├── Protocol unusable
└── Recovery impossible""",
        "prerequisites": "- Knowledge of all attack vectors\n- Coordinated execution\n- Comprehensive target analysis\n- Economic motivation for scale",
        "impact": "- **Total ENS Compromise**: Complete protocol failure\n- **Economic Warfare**: Billions in damage potential\n- **Trust Destruction**: Irreversible reputation loss\n- **Ecosystem Collapse**: All dependent dApps broken",
        "sub_paths": "### 30.1 ENS Registry Takeover\n### 30.2 Economic Exploitation Cascade\n### 30.3 User Fund Total Drain"
    }
]

def generate_trace_graph(path_data):
    """Generate a trace graph file from path data"""
    content = TRACE_TEMPLATE.format(
        path_num=path_data["num"],
        title=path_data["title"],
        overview=path_data["overview"],
        diagram=path_data["diagram"],
        call_trace=path_data["call_trace"],
        state_analysis=path_data["state_analysis"],
        prerequisites=path_data["prerequisites"],
        impact=path_data["impact"],
        sub_paths=path_data["sub_paths"]
    )

    filename = f"attack_trace_graphs/path_{path_data['num']}_{path_data['title'].lower().replace(' ', '_')}.md"
    with open(filename, 'w') as f:
        f.write(content)
    print(f"Generated: {filename}")

if __name__ == "__main__":
    # Generate all trace graphs
    for path_data in paths_data:
        generate_trace_graph(path_data)
    print("All trace graphs generated!")