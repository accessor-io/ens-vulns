# PATH 19: CONSTRUCTOR RE-EXECUTION

## Attack Vector Overview
Delegatecall execution that mimics constructor logic, potentially re-initializing contract state or manipulating immutable variables.

## State Transition Diagram

```
[Contract Deployment State]
       |
       | Constructor already executed
       v
[Multicall Exploitation]
       |
       | delegatecall(constructorLikeFunction)
       v
[Constructor Logic Execution]
       |
       +-------------------+
       |                   |
       v                   v
[State Re-Initialization] [Immutable Manipulation]
       |                   |
       | Reset storage     | Attempt to change
       v                   | immutable variables
[Storage Corruption]     [Contract Instability]
       |                   |
       +-------------------+
       |                   |
       v                   v
[Configuration Reset]    [Logic Corruption]
       |                   |
       | Contract becomes  | Invalid state transitions
       | unconfigurable    |
       v                   v
[Contract Bricking]      [Permanent Damage]
```

## Function Call Trace

### Constructor Logic Simulation
```
Constructor-Like Execution:
├── Normal constructor: Initializes immutables and storage
├── Delegatecall: Attempts to re-run initialization
├── Storage layout: Same as constructor expectations
└── State corruption: Overwrites initialized values

Immutable Variable Attacks:
├── Constructor sets: immutable trustedETHController
├── Delegatecall attempts: trustedETHController = attacker
├── EVM behavior: Immutable variables can't change
└── Result: Contract instability or revert
```

### Storage Re-Initialization
```
Storage Reset Attempts:
├── Constructor initializes: mappings, arrays, variables
├── Delegatecall re-initializes with attacker values
├── Storage collisions: Overwrites legitimate data
└── Contract state becomes invalid

Configuration Manipulation:
├── Constructor sets: owner, parameters, constants
├── Delegatecall attempts: Change configuration
├── Authorization impact: Control transfers to attacker
└── Contract becomes attacker-controlled
```

## State Change Analysis

### Constructor State Recreation
```
Original Constructor State:
├── trustedETHController = legitimateController
├── _operatorApprovals = empty
├── recordVersions = initialized
└── Contract properly configured

Re-Execution Attempt:
├── delegatecall tries to reset trustedETHController
├── Immutable variables: Cannot change (revert)
├── Mutable storage: Gets overwritten
└── Contract enters invalid state

Final State Corruption:
├── Some variables reset to constructor defaults
├── Others retain current values
├── Inconsistent configuration
└── Contract behavior unpredictable
```

### Initialization Invariant Breaking
```
Constructor Assumptions:
├── Executed exactly once during deployment
├── Immutable variables set permanently
├── Storage initialized to known state
└── Configuration finalized

Violation Consequences:
├── Multiple initialization attempts
├── State consistency destroyed
├── Contract logic depends on violated assumptions
└── All operations become unreliable
```

## Prerequisites and Conditions
- Functions that mimic constructor logic
- Storage layout compatible with constructor expectations
- Attempted manipulation of immutable variables
- Constructor-like initialization patterns

## Impact Assessment
- **Contract Re-Initialization**: State reset to constructor defaults
- **Configuration Corruption**: Contract becomes misconfigured
- **Immutable Variable Attacks**: Contract instability from failed changes
- **Logic Assumption Breaking**: All contract logic becomes unreliable

## Sub-path Exploitation

### 19.1 State Re-Initialization
**Mechanism**: Re-run constructor-like logic to reset contract state
**Impact**: Contract returns to initial state, losing all configuration

### 19.2 Immutable Variable Manipulation
**Mechanism**: Attempt to change immutable variables post-deployment
**Impact**: Contract becomes unstable or unusable

### 19.3 Configuration Reset
**Mechanism**: Overwrite constructor-set configuration values
**Impact**: Contract loses proper configuration, becomes inoperable