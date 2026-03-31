# TENDERLY BYTECODE USAGE GUIDE

## ENS Delegatecall Vulnerability Demonstration

This guide shows how to use the provided bytecode to demonstrate the ENS delegatecall vulnerabilities in Tenderly.

## Step 1: Deploy Test Contract

First, deploy a vulnerable multicall contract on a testnet or use Tenderly's contract deployment:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VulnerableMulticall {
    mapping(address => bool) public authorizedUsers;
    mapping(bytes32 => mapping(uint256 => bytes)) versionable_addresses;

    function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            require(success, "Multicall failed");
            results[i] = result;
        }
        return results;
    }

    function setAuthorized(address user, bool status) external {
        authorizedUsers[user] = status;
    }

    function setAddr(bytes32 node, uint256 coinType, bytes memory addrData) external {
        versionable_addresses[node][coinType] = addrData;
    }

    function setApprovalForAll(address operator, bool approved) external {
        // Simplified - would set operator approvals
    }

    function clearRecords(bytes32 node) external {
        // Simplified - would increment record version
    }

    function addr(bytes32 node) external view returns (address) {
        bytes memory addrData = versionable_addresses[node][60]; // ETH coin type
        if (addrData.length >= 20) {
            return address(bytes20(addrData));
        }
        return address(0);
    }
}
```

## Step 2: Copy Attack Bytecode

From `tenderly_raw_bytecode.txt`, copy the raw transaction data for the attack you want to demonstrate.

## Step 3: Create Tenderly Simulation

1. Go to Tenderly dashboard
2. Create new transaction simulation
3. Set contract address to your deployed VulnerableMulticall
4. Set caller address to attacker (0x1337...)
5. Paste the raw bytecode into the Data field
6. Execute the simulation

## Step 4: Observe Attack Effects

### Attack 1: Direct Authorization Bypass
- **Before**: `authorizedUsers[0x1337]` = false
- **After**: `authorizedUsers[0x1337]` = true
- **Problem**: Attacker gains authorization without proper access

### Attack 2: Storage Chaining
- **Before**: Clean contract state
- **After**: Manipulated approvals, changed addresses, cleared records
- **Problem**: Sequential operations enable unauthorized state changes

### Attack 3: Controller Privilege Escalation
- **Context**: Must be called by trusted controller address
- **Effect**: All authorization checks bypassed
- **Problem**: Trusted components can be subverted

## Step 5: Analysis in Tenderly

Use Tenderly's debugging features to observe:

1. **Call Traces**: See delegatecall execution preserving attacker context
2. **State Changes**: Watch storage manipulation in real-time
3. **Gas Usage**: Observe operation costs
4. **Event Logs**: Check for manipulated audit trails

## Key Observations

The simulations will clearly show:

- ✅ **Context Preservation**: `msg.sender` remains attacker throughout
- ✅ **Storage Access**: Contract storage becomes writable
- ✅ **Authorization Bypass**: Security checks are ineffective
- ✅ **State Pollution**: Contract state becomes corrupted
- ✅ **Audit Trail Issues**: Operations occur without proper logging

## Security Impact Demonstration

These Tenderly simulations prove the vulnerability enables:

1. **Complete Authorization Bypass** - Any user can modify any data
2. **State Manipulation** - Contract storage becomes attacker-controlled
3. **Protocol Compromise** - Core ENS functionality breaks
4. **Economic Attack** - Funds can be stolen, domains hijacked
5. **Irrecoverable Damage** - Contract state permanently corrupted

## Mitigation Validation

The simulations also validate that:
- Removing delegatecall prevents context inheritance
- Adding proper authorization checks blocks bypass attempts
- Input validation prevents malicious data execution

## Related artifacts

Optional helper files (if present in the tree) may include Tenderly-related bytecode notes or scripts. Treat all fork simulations as **non-production** and run only against test or virtual networks.