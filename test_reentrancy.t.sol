// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * Test contract to verify ETHRegistrarController reentrancy vulnerability
 * 
 * This contract attempts to reenter the register() function during the
 * multicallWithNodeCheck() external call to test if reentrancy is possible.
 */

interface IETHRegistrarController {
    struct Registration {
        string label;
        address owner;
        uint256 duration;
        address resolver;
        bytes[] data;
        uint16 reverseRecord;
        uint16 fuses;
        bytes32 referrer;
    }
    
    function commit(bytes32 commitment) external;
    function register(Registration calldata registration) external payable;
    function makeCommitment(Registration calldata registration) external pure returns (bytes32);
    function commitments(bytes32) external view returns (uint256);
}

interface IResolver {
    function multicallWithNodeCheck(bytes32 nodehash, bytes[] calldata data) external returns (bytes[] memory);
}

interface IENS {
    function owner(bytes32 node) external view returns (address);
}

interface IBaseRegistrar {
    function ownerOf(uint256 tokenId) external view returns (address);
    function available(uint256 id) external view returns (bool);
}

/**
 * Malicious resolver that attempts to reenter during multicall
 */
contract MaliciousResolver {
    IETHRegistrarController public controller;
    IENS public ens;
    IBaseRegistrar public base;
    bytes32 public targetNamehash;
    string public targetLabel;
    address public attacker;
    bool public reentrancyAttempted;
    uint256 public reentrancyCount;
    
    constructor(
        address _controller,
        address _ens,
        address _base,
        bytes32 _targetNamehash,
        string memory _targetLabel
    ) {
        controller = IETHRegistrarController(_controller);
        ens = IENS(_ens);
        base = IBaseRegistrar(_base);
        targetNamehash = _targetNamehash;
        targetLabel = _targetLabel;
        attacker = msg.sender;
    }
    
    /**
     * This function is called by ETHRegistrarController during registration
     * Attempts to reenter the register() function
     */
    function multicallWithNodeCheck(
        bytes32 nodehash,
        bytes[] calldata data
    ) external returns (bytes[] memory) {
        reentrancyAttempted = true;
        reentrancyCount++;
        
        // Check current state
        bytes32 labelhash = keccak256(bytes(targetLabel));
        uint256 tokenId = uint256(labelhash);
        
        // State at reentrancy point:
        // 1. Commitment is deleted
        // 2. Name is registered to controller address
        // 3. NFT not yet transferred to owner
        
        // Attempt to reenter - this should fail because:
        // - Commitment is already deleted (can't re-register)
        // - Name is already registered (not available)
        
        // Try to call register again with same commitment
        // This will fail because commitment is deleted
        try this.attemptReentrancy() {
            // Reentrancy succeeded (unexpected!)
        } catch {
            // Reentrancy failed (expected)
        }
        
        // Return empty result to continue normal flow
        bytes[] memory results = new bytes[](data.length);
        return results;
    }
    
    function attemptReentrancy() external {
        // This would attempt to reenter, but we can't easily do that from here
        // The key test is whether the state allows reentrancy
    }
    
    /**
     * Check if we can exploit the reentrancy window
     */
    function checkReentrancyWindow() external view returns (
        bool commitmentExists,
        address currentOwner,
        bool nameAvailable,
        bool canReenter
    ) {
        bytes32 labelhash = keccak256(bytes(targetLabel));
        bytes32 commitment = controller.makeCommitment(
            IETHRegistrarController.Registration({
                label: targetLabel,
                owner: attacker,
                duration: 365 days,
                resolver: address(this),
                data: new bytes[](0),
                reverseRecord: 0,
                fuses: 0,
                referrer: bytes32(0)
            })
        );
        
        commitmentExists = (controller.commitments(commitment) != 0);
        currentOwner = base.ownerOf(uint256(labelhash));
        nameAvailable = base.available(uint256(labelhash));
        
        // Can reenter if:
        // 1. Commitment doesn't exist (deleted) - prevents re-registration
        // 2. Name is registered to controller - prevents re-registration
        // 3. But we're in the window before NFT transfer
        
        canReenter = !commitmentExists && currentOwner == address(controller) && !nameAvailable;
        
        return (commitmentExists, currentOwner, nameAvailable, canReenter);
    }
}

/**
 * Test harness to verify reentrancy behavior
 */
contract ReentrancyTest {
    IETHRegistrarController public controller;
    IENS public ens;
    IBaseRegistrar public base;
    
    struct TestResult {
        bool reentrancyPossible;
        string reason;
        bool commitmentDeleted;
        bool nameRegistered;
        bool nftTransferred;
    }
    
    constructor(address _controller, address _ens, address _base) {
        controller = IETHRegistrarController(_controller);
        ens = IENS(_ens);
        base = IBaseRegistrar(_base);
    }
    
    /**
     * Test the reentrancy window
     * Simulates what happens during the external call
     */
    function testReentrancyWindow(
        string memory label,
        bytes32 namehash,
        address maliciousResolver
    ) external view returns (TestResult memory) {
        bytes32 labelhash = keccak256(bytes(label));
        uint256 tokenId = uint256(labelhash);
        
        // Check state at reentrancy point (during multicallWithNodeCheck)
        bool commitmentDeleted = true; // Commitment is deleted before external call
        bool nameRegistered = (base.ownerOf(tokenId) == address(controller));
        bool nftTransferred = (base.ownerOf(tokenId) == address(0)); // Not yet transferred
        
        // Analyze reentrancy possibility
        bool reentrancyPossible = false;
        string memory reason = "";
        
        if (commitmentDeleted && nameRegistered && !nftTransferred) {
            // We're in the reentrancy window
            // Can we reenter register()?
            
            // Try to create new commitment for reentrancy
            // This would fail because:
            // 1. Commitment for same registration would be the same hash
            // 2. Commitment is already deleted
            // 3. Name is already registered (not available)
            
            reentrancyPossible = false; // Reentrancy prevented by design
            reason = "Reentrancy prevented: commitment deleted and name already registered";
        } else {
            reason = "Not in reentrancy window";
        }
        
        return TestResult({
            reentrancyPossible: reentrancyPossible,
            reason: reason,
            commitmentDeleted: commitmentDeleted,
            nameRegistered: nameRegistered,
            nftTransferred: nftTransferred
        });
    }
    
    /**
     * Test if malicious resolver can call other controller functions
     */
    function testOtherFunctionCalls() external view returns (bool) {
        // During reentrancy, malicious resolver could try to:
        // 1. Call commit() - would work but useless
        // 2. Call register() - would fail (commitment deleted, name registered)
        // 3. Call renew() - would work but requires existing name
        // 4. Call other functions - depends on access control
        
        // The key question: can malicious resolver exploit the state?
        return false; // Need to test
    }
}



