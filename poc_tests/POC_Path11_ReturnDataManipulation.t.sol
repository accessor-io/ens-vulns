// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/PublicResolver.sol";
import "../contracts/ENSRegistry.sol";

contract POC_Path11_ReturnDataManipulation is Test {
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
    }

    function test_Path11_ReturnDataManipulation() public {
        // This test demonstrates that multicall continues even when individual calls fail
        // In a real attack, failed calls could manipulate return data used by subsequent calls

        bytes[] memory mixedCalls = new bytes[](3);

        // Call 1: Valid call that succeeds
        mixedCalls[0] = abi.encodeCall(resolver.setText, (testNode, "key1", "value1"));

        // Call 2: Call that will fail (unauthorized)
        mixedCalls[1] = abi.encodeCall(resolver.setAddr, (testNode, attacker)); // Should fail

        // Call 3: Another valid call - this demonstrates multicall continues despite Call 2 failure
        mixedCalls[2] = abi.encodeCall(resolver.setText, (testNode, "key3", "value3"));

        // Multicall should complete despite the failed middle call
        vm.prank(attacker);
        resolver.multicall(mixedCalls);

        // Verify Call 1 and Call 3 succeeded, Call 2 failed (address unchanged)
        assertEq(resolver.text(testNode, "key1"), "value1");
        assertEq(resolver.text(testNode, "key3"), "value3");
        assertEq(resolver.addr(testNode), victim); // Unchanged due to authorization failure
    }
}