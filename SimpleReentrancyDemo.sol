// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Ultra-simple demonstration of the reentrancy vulnerability
// No complex inheritance, just the core issue

contract VulnerableUnwrap {
    mapping(bytes32 => address) public ensOwner;
    mapping(address => mapping(uint256 => uint256)) public tokenBalance;

    event TokenBurned(bytes32 node, address owner);
    event ENSOwnershipTransferred(bytes32 node, address newOwner);
    event CallbackExecuted(bytes32 node);

    // VULNERABLE FUNCTION - External call before state update
    function unwrap(bytes32 node) external {
        require(tokenBalance[msg.sender][uint256(node)] > 0, "Not owner");

        // EXTERNAL CALL FIRST - This can trigger callbacks
        _burnToken(node, msg.sender);

        // STATE UPDATE AFTER - Too late!
        ensOwner[node] = msg.sender;
        emit ENSOwnershipTransferred(node, msg.sender);
    }

    function _burnToken(bytes32 node, address owner) internal {
        tokenBalance[owner][uint256(node)] = 0;
        emit TokenBurned(node, owner);

        // In real ERC1155, this would trigger callbacks here
        // For demo, we'll simulate the callback
        _simulateCallback(node, owner);
    }

    function _simulateCallback(bytes32 node, address owner) internal {
        // This simulates what happens during _burn() callback execution
        // In the real attack, an attacker would implement this in their contract

        emit CallbackExecuted(node);

        // VULNERABILITY: At this point:
        // - Token is burned ✅
        // - ENS ownership is NOT yet updated ❌
        // - Attacker can manipulate state here
    }

    // Helper functions for testing
    function mintToken(bytes32 node, address to) external {
        tokenBalance[to][uint256(node)] = 1;
        ensOwner[node] = address(this); // "wrapped" state
    }

    function getTokenBalance(address owner, bytes32 node) external view returns (uint256) {
        return tokenBalance[owner][uint256(node)];
    }

    function getENSOwner(bytes32 node) external view returns (address) {
        return ensOwner[node];
    }
}

contract AttackerDemo {
    VulnerableUnwrap public vulnerable;
    bytes32 public targetNode;
    address public attacker;
    bool public callbackExecuted = false;

    event AttackTriggered(bytes32 node, address attacker);

    constructor(address _vulnerable) {
        vulnerable = VulnerableUnwrap(_vulnerable);
        attacker = msg.sender;
    }

    // This function simulates what would happen in onERC1155Received
    function simulateCallback(bytes32 node) external {
        // This executes DURING the vulnerable unwrap() call
        callbackExecuted = true;
        targetNode = node;

        emit AttackTriggered(node, attacker);

        // In a real attack, the attacker could:
        // 1. Check that ENS ownership hasn't been updated yet
        // 2. Call external contracts to manipulate state
        // 3. Steal the domain by calling ens.setOwner()

        // For this demo, we just log that the callback executed
        // proving the reentrancy window exists
    }

    function attack(bytes32 node) external {
        targetNode = node;
        callbackExecuted = false;

        // Call unwrap - this will trigger our callback simulation
        vulnerable.unwrap(node);
    }

    function getAttackStatus() external view returns (bool executed, bytes32 node) {
        return (callbackExecuted, targetNode);
    }
}