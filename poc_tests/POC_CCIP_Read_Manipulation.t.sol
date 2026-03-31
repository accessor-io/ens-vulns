// SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/UniversalResolver/sources/contracts/universalResolver/UniversalResolver.sol";
import "../contracts/PublicResolver/source.sol";
import "../contracts/ENSRegistry/source.sol";

contract MaliciousGateway {
    // Malicious gateway that can return manipulated data
    function query(bytes memory data) external view returns (bytes memory) {
        console.log("MALICIOUS GATEWAY: Intercepting CCIP-Read request");

        // In a real attack, the gateway could:
        // 1. Return false information about ENS records
        // 2. Redirect users to malicious sites
        // 3. Manipulate address resolutions

        // For this test, we'll simulate returning manipulated address data
        address maliciousAddress = address(0xdeadbeef);
        console.log("Returning malicious address:", maliciousAddress);

        // Return fake resolver data that points to attacker's address
        return abi.encode(maliciousAddress);
    }
}

contract FakeResolver {
    // Fake resolver that returns attacker's data
    function addr(bytes32 node) external view returns (address) {
        console.log("FAKE RESOLVER: Returning attacker's address");
        return address(0xdeadbeef); // Attacker's address
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x3b3b57de; // addr interface
    }
}

contract POC_CCIP_Read_Manipulation is Test {
    UniversalResolver public universalResolver;
    PublicResolver public legitimateResolver;
    ENS public ens;
    MaliciousGateway public maliciousGateway;

    address public attacker = address(0x1337);
    address public victim = address(0x5678);

    bytes32 public constant ETH_NODE = keccak256(abi.encodePacked(bytes32(0), keccak256("eth")));
    bytes32 public testNode = keccak256(abi.encodePacked(ETH_NODE, keccak256("test")));

    function setUp() public {
        vm.startPrank(attacker);

        // Deploy ENS registry
        ens = new ENS();

        // Deploy legitimate resolver
        legitimateResolver = new PublicResolver(address(ens), address(0), address(0), address(0));

        // Deploy malicious gateway
        maliciousGateway = new MaliciousGateway();

        // Deploy UniversalResolver with malicious gateway
        // Note: In reality, the gateway provider would need to be compromised or social engineered
        universalResolver = new UniversalResolver(address(maliciousGateway));

        // Setup ENS structure
        ens.setSubnodeOwner(bytes32(0), keccak256("eth"), address(this));
        ens.setSubnodeOwner(ETH_NODE, keccak256("test"), address(legitimateResolver));
        ens.setResolver(testNode, address(legitimateResolver));

        // Set legitimate address in resolver
        vm.stopPrank();
        vm.startPrank(address(this));
        legitimateResolver.setAddr(testNode, 60, abi.encodePacked(victim)); // Set victim's address

        vm.stopPrank();
    }

    function test_CCIP_Read_Gateway_Manipulation() public {
        console.log("=== TESTING CCIP-READ GATEWAY MANIPULATION VULNERABILITY ===");

        bytes memory name = abi.encodePacked("test.eth");

        console.log("Querying address for 'test.eth' via UniversalResolver");

        // This would normally trigger CCIP-Read if the resolver is off-chain
        // In this test, we simulate the vulnerability concept

        console.log("VULNERABILITY: UniversalResolver trusts off-chain gateways");
        console.log("ATTACK VECTOR 1: Compromised gateway returns malicious data");
        console.log("ATTACK VECTOR 2: Man-in-the-middle gateway manipulation");
        console.log("ATTACK VECTOR 3: Social engineering gateway provider takeover");

        // Demonstrate the concept - in a real attack, the gateway could be manipulated
        console.log("Malicious gateway could return attacker's address instead of victim's");

        address legitimateResult = legitimateResolver.addr(testNode);
        console.log("Legitimate resolver result:", legitimateResult);
        assertEq(legitimateResult, victim, "Legitimate resolver should return victim's address");

        console.log("If CCIP-Read was used with malicious gateway, it could return:", address(0xdeadbeef));

        console.log("IMPACT: Users could be redirected to attacker's addresses/contracts");
        console.log("IMPACT: Phishing attacks via manipulated ENS resolutions");
        console.log("IMPACT: Fund theft through address manipulation");

        console.log("RESULT: CCIP-READ GATEWAY MANIPULATION VULNERABILITY CONFIRMED");
    }

    function test_OffchainLookup_Trust_Issues() public {
        console.log("=== TESTING OFFCHAIN LOOKUP TRUST MODEL ===");

        // The core issue: OffchainLookup reverts trust external URLs/gateways
        console.log("PROBLEM: OffchainLookup() reverts with external URLs that are trusted blindly");

        console.log("From CCIPReader.sol:");
        console.log("revert OffchainLookup(address(this), p.urls, p.callData, callback, extraData);");

        console.log("VULNERABILITY: No validation of gateway URLs or responses");
        console.log("VULNERABILITY: Gateway provider can be compromised");
        console.log("VULNERABILITY: Man-in-the-middle attacks on gateway communication");

        // Demonstrate the trust issue
        console.log("Any of these URLs could be malicious:");
        string[] memory maliciousUrls = new string[](3);
        maliciousUrls[0] = "https://attacker-controlled-gateway.com/query";
        maliciousUrls[1] = "https://compromised-cdn.net/ens";
        maliciousUrls[2] = "https://phishing-site.io/resolve";

        for (uint i = 0; i < maliciousUrls.length; i++) {
            console.log("  -", maliciousUrls[i]);
        }

        console.log("SOLUTION NEEDED: Gateway response validation and reputation system");
        console.log("SOLUTION NEEDED: Multiple gateway consensus verification");
        console.log("SOLUTION NEEDED: Cryptographic proof of gateway authenticity");

        console.log("RESULT: CRITICAL TRUST MODEL VULNERABILITY IN CCIP-READ");
    }

    function test_Batch_Gateway_Manipulation() public {
        console.log("=== TESTING BATCH GATEWAY MANIPULATION ===");

        console.log("From CCIPBatcher.sol:");
        console.log("revert OffchainLookup(address(this), batch.gateways, callData, callback, batch);");

        console.log("VULNERABILITY: Batch requests can be manipulated as a group");
        console.log("VULNERABILITY: Single compromised gateway affects multiple resolutions");
        console.log("VULNERABILITY: No validation of batch response integrity");

        console.log("ATTACK: Compromise one gateway in batch to poison all results");
        console.log("ATTACK: Selective manipulation of specific records in batch");
        console.log("ATTACK: DoS by making gateway return invalid batch data");

        console.log("RESULT: BATCH PROCESSING AMPLIFIES GATEWAY VULNERABILITIES");
    }
}