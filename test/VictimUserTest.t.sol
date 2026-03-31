// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/MaliciousResolverAdvanced.sol";

// Mocking the Public Resolver for the test
contract MockPublicResolver is IAddrResolver {
    mapping(bytes32 => address) public records;

    function setAddr(bytes32 node, address a) public {
        records[node] = a;
    }

    function addr(bytes32 node) external view override returns (address payable) {
        return payable(records[node]);
    }
}

contract VictimUserTest is Test {
    
    // FIX: Using the concrete contract type instead of the missing 'IMaliciousResolver' interface
    MaliciousResolverAdvanced maliciousResolver;
    MockPublicResolver publicResolver;

    address victim = address(0x123);
    address attacker = address(0x666);
    address realTarget = address(0xABC);
    address trapTarget = address(0xDEAD);

    bytes32 testNode = keccak256("vitalik.eth");

    function setUp() public {
        // 1. Deploy the "Real" Public Resolver and set a legit record
        publicResolver = new MockPublicResolver();
        publicResolver.setAddr(testNode, realTarget);

        // 2. Deploy our Malicious Resolver, pointing to the Public one
        vm.prank(attacker);
        maliciousResolver = new MaliciousResolverAdvanced(address(publicResolver));
    }

    function testTransparentForwarding() public {
        // SCENARIO 1: No malicious entry set.
        // The resolver should transparently fetch the real address.
        
        address result = maliciousResolver.addr(testNode);
        assertEq(result, realTarget, "Should forward to real target when no trap is set");
    }

    function testMaliciousInterception() public {
        // SCENARIO 2: Attacker sets a trap.
        
        vm.prank(attacker);
        maliciousResolver.setMaliciousAddress(testNode, trapTarget);

        // Victim resolves the name
        vm.prank(victim);
        address result = maliciousResolver.addr(testNode);

        // Should return the TRAP, not the real target
        assertEq(result, trapTarget, "Should return the trap address");
        assertTrue(result != realTarget, "Should NOT return the real address");
    }
}