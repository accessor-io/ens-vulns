# PATH 28: REVERT DATA CHAINING ATTACKS

## Attack Vector Overview
Using revert data from failed operations as input to subsequent operations in the multicall batch.

## State Transition Diagram

```
[Multicall Batch Execution]
       |
       | Call 1 intentionally fails
       v
[Revert with Attacker Data]
       |
       | revert(attackerControlledData)
       v
[Call 2 Processes Revert Data]
       |
       +-------------------+
       |                   |
       v                   v
[Data Injection]         [Error Handling Abuse]
       |                   |
       | Malicious input   | try/catch exploitation
       v                   | using revert data
[Parameter Poisoning]   [Exception State]
       |                   |
       +-------------------+
       |                   |
       v                   v
[Logic Corruption]      [State Machine Break]
```

## Function Call Trace

### Revert Data Chain Exploitation
```
Call 1 Failure:
├── Intentionally triggers revert
├── revert() includes attacker data
├── Transaction doesn't revert (multicall continues)
└── Revert data available to next call

Call 2 Exploitation:
├── Receives revert data as input
├── Processes attacker-controlled payload
├── State manipulated by poisoned input
└── Contract logic corrupted
```

## State Change Analysis

### Revert Data Propagation
```
Error State Chain:
├── Call 1: revert(attackerData) → stored in memory
├── Call 2: abi.decode(attackerData) → malicious parameters
├── Call 3: operates on corrupted state from Call 2
└── Final state: Completely compromised

Exception Handling Abuse:
├── try/catch blocks process revert data
├── Error paths become attack vectors
├── Recovery logic corrupted by attacker input
└── Contract enters invalid error recovery state
```

## Prerequisites and Conditions
- Multicall continues after individual call failures
- Functions process revert data from previous calls
- try/catch blocks or error handling logic
- Revert data used as input to subsequent operations

## Impact Assessment
- **Data Poisoning**: Functions receive malicious input via errors
- **Logic Corruption**: Error paths become attack vectors
- **State Machine Breaking**: Exception handling leads to invalid states
- **Recovery Prevention**: Error recovery mechanisms corrupted

## Sub-path Exploitation

### 28.1 Revert Data Poisoning
**Mechanism**: Use revert data as malicious input to next call
**Impact**: Functions process attacker-controlled error data

### 28.2 Exception Handling Abuse
**Mechanism**: Exploit try/catch blocks with revert data
**Impact**: Error recovery logic becomes attack vector

### 28.3 Error State Propagation
**Mechanism**: Error states cascade through multicall batch
**Impact**: Contract enters invalid error recovery states