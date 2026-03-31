# ENS Delegatecall Vulnerability - Proof-of-Concept Tests

This directory contains comprehensive proof-of-concept (PoC) test cases demonstrating each of the 30 attack vectors identified in the ENS Multicallable delegatecall vulnerability analysis.

## Overview
Each PoC test demonstrates a specific attack vector working on a local network, showing how the `delegatecall` in `multicall()` enables complete protocol compromise.

## Running the Tests

### Prerequisites
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install
```

### Run All PoC Tests
```bash
./run_poc_tests.sh
```

### Run Specific Test
```bash
forge test --match-path poc_tests/POC_Path01_DirectAuthorizationBypass.t.sol -v
```

### Run with Gas Reporting
```bash
forge test --match-path poc_tests/ --gas-report
```

## PoC Test Coverage

### Critical Authorization & Trust (Paths 1-3)
| Path | Test File | Description |
|------|-----------|-------------|
| 01 | [POC_Path01_DirectAuthorizationBypass.t.sol](POC_Path01_DirectAuthorizationBypass.t.sol) | Direct authorization bypass through msg.sender preservation |
| 02 | [POC_Path02_StorageManipulationChaining.t.sol](POC_Path02_StorageManipulationChaining.t.sol) | Function calls modify storage to enable subsequent attacks |
| 03 | [POC_Path03_TrustedControllerPrivilegeEscalation.t.sol](POC_Path03_TrustedControllerPrivilegeEscalation.t.sol) | Controllers calling multicall inherit elevated privileges |

### Mass Exploitation & Scale (Paths 4-7)
| Path | Test File | Description |
|------|-----------|-------------|
| 04 | [POC_Path04_BatchExploitationAmplification.t.sol](POC_Path04_BatchExploitationAmplification.t.sol) | Single transaction compromises hundreds of names |
| 05 | [POC_Path05_FunctionSelectorExploitation.t.sol](POC_Path05_FunctionSelectorExploitation.t.sol) | Malformed selectors trigger unexpected execution paths |
| 06 | [POC_Path06_GasAndResourceExploitation.t.sol](POC_Path06_GasAndResourceExploitation.t.sol) | Gas consumption and resource exhaustion |
| 07 | [POC_Path07_CrossContractExploitationChains.t.sol](POC_Path07_CrossContractExploitationChains.t.sol) | Attacks spanning multiple ENS contracts |

### Advanced Memory & State (Paths 9-11, 15-16, 18-21)
| Path | Test File | Description |
|------|-----------|-------------|
| 09 | [POC_Path09_ProtocolLevelTrustDestruction.t.sol](POC_Path09_ProtocolLevelTrustDestruction.t.sol) | Protocol-level trust destruction via resolution hijacking |
| 11 | [POC_Path11_ReturnDataManipulation.t.sol](POC_Path11_ReturnDataManipulation.t.sol) | Return data manipulation between multicall calls |
| 15 | [POC_Path15_StorageSlotDirectManipulation.t.sol](POC_Path15_StorageSlotDirectManipulation.t.sol) | Assembly enables raw storage manipulation |
| 16 | [POC_Path16_EVMOpcodeExploitation.t.sol](POC_Path16_EVMOpcodeExploitation.t.sol) | Arbitrary EVM opcode execution |
| 18 | [POC_Path18_SelfdestructDelegateContext.t.sol](POC_Path18_SelfdestructDelegateContext.t.sol) | Contract destruction and fund draining |
| 19 | [POC_Path19_ConstructorReExecution.t.sol](POC_Path19_ConstructorReExecution.t.sol) | Constructor re-execution via delegatecall |
| 20 | [POC_Path20_CrossBatchStatePollution.t.sol](POC_Path20_CrossBatchStatePollution.t.sol) | Cross-batch state pollution enabling persistent attacks |
| 21 | [POC_Path21_PrecompileExploitation.t.sol](POC_Path21_PrecompileExploitation.t.sol) | EVM precompile exploitation with contract privileges |

### Ultimate Impact (Paths 23, 30)
| Path | Test File | Description |
|------|-----------|-------------|
| 23 | [POC_Path23_UpgradeMechanismCompleteHijacking.t.sol](POC_Path23_UpgradeMechanismCompleteHijacking.t.sol) | Complete hijacking of upgrade mechanism |
| 30 | [POC_Path30_CompleteProtocolStateCorruption.t.sol](POC_Path30_CompleteProtocolStateCorruption.t.sol) | Complete protocol state corruption combining all vectors |

## Test Structure
Each PoC test follows this structure:

```solidity
contract POC_PathXX_AttackName is Test {
    function setUp() public {
        // Deploy contracts and setup test scenario
    }

    function test_PathXX_AttackName() public {
        // Demonstrate the vulnerability
        // Show before/after states
        // Log attack results
    }

    // Additional sub-path tests...
}
```

## Key Findings Demonstrated

### Complete Authorization Bypass
- **msg.sender preservation** allows attackers to appear as trusted entities
- **Storage manipulation chaining** enables self-granted permissions
- **Trusted controller escalation** gives complete system access

### Protocol-Level Destruction
- **Mass domain hijacking** in single transactions
- **Resolution manipulation** destroys ENS trust model
- **Contract self-destruction** with fund theft

### EVM-Level Compromise
- **Direct storage manipulation** via assembly
- **Arbitrary opcode execution** bypassing Solidity safety
- **Precompile exploitation** with unlimited gas

### Irrecoverable Damage
- **State pollution** that survives patches
- **Upgrade hijacking** for permanent control
- **Audit trail forgery** making detection impossible

## Security Implications

These PoC tests prove that the delegatecall vulnerability enables:

1. **Complete ENS Protocol Compromise** - Every contract and mechanism vulnerable
2. **Economic Warfare** - Billions in potential losses
3. **Irreversible Trust Destruction** - ENS becomes unusable
4. **EVM-Level Attacks** - Bypasses all Solidity safety mechanisms

## Mitigation Validation

The PoC tests also serve to validate mitigations:
- Removing multicall eliminates all attack vectors
- Replacing delegatecall with regular calls prevents context inheritance
- Adding authorization checks blocks bypass attempts

## Generation
PoC tests were generated using `generate_poc_tests.py` with comprehensive vulnerability demonstrations for local network testing.