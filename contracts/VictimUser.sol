// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title VictimUser
 * @notice Mock contract representing a user/DApp unknowingly sending funds to a malicious resolver
 * @dev This contract demonstrates how a user would be tricked into sending funds to an attacker
 */
interface IENS {
    function resolver(bytes32 node) external view returns (address);
}

interface IAddrResolver {
    function addr(bytes32 node) external view returns (address payable);
}

contract VictimUser {
    // Mainnet addresses
    address constant MAINNET_ENS = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant MAINNET_PUBLIC_RESOLVER = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
    
    IENS public immutable ens;
    
    // Tracking
    mapping(bytes32 => address) public resolvedAddresses;
    mapping(bytes32 => uint256) public sentAmounts;
    mapping(bytes32 => bool) public fundsSent;
    
    event FundsSent(bytes32 indexed namehash, address to, uint256 amount, bool wasRedirected);
    event AddressResolved(bytes32 indexed namehash, address resolved, address expected);
    
    constructor() {
        ens = IENS(MAINNET_ENS);
    }
    
    /**
     * @notice User wants to send funds to an ENS name
     * @dev This simulates what a DApp or user would do
     * @param namehash The namehash of the ENS name (e.g., "vitalik.eth")
     * @param expectedAddress The address the user EXPECTS to send to (for verification)
     */
    function sendFundsToENSName(
        bytes32 namehash,
        address expectedAddress
    ) external payable {
        require(msg.value > 0, "Must send some ETH");
        
        // Step 1: Resolve the ENS name to get the address
        address resolverAddress = ens.resolver(namehash);
        require(resolverAddress != address(0), "No resolver found for name");
        
        // Step 2: Query the resolver for the address
        address resolvedAddress = IAddrResolver(resolverAddress).addr(namehash);
        require(resolvedAddress != address(0), "No address set for name");
        
        // Step 3: Store the resolved address
        resolvedAddresses[namehash] = resolvedAddress;
        
        // Step 4: Check if this matches what we expected (in real scenario, user wouldn't know)
        bool wasRedirected = (resolvedAddress != expectedAddress && expectedAddress != address(0));
        
        emit AddressResolved(namehash, resolvedAddress, expectedAddress);
        
        // Step 5: Send funds to the resolved address
        // ⚠️ USER THINKS THEY'RE SENDING TO CORRECT ADDRESS
        // ⚠️ BUT IF RESOLVER IS MALICIOUS, FUNDS GO TO ATTACKER
        (bool success, ) = resolvedAddress.call{value: msg.value}("");
        require(success, "Transfer failed");
        
        sentAmounts[namehash] = msg.value;
        fundsSent[namehash] = true;
        
        emit FundsSent(namehash, resolvedAddress, msg.value, wasRedirected);
    }
    
    /**
     * @notice User wants to send funds to an ENS name (simpler version)
     * @dev This is what most DApps would do - just resolve and send
     * @param namehash The namehash of the ENS name
     */
    function sendFundsToENSNameSimple(bytes32 namehash) external payable {
        require(msg.value > 0, "Must send some ETH");
        
        // Resolve name to address
        address resolverAddress = ens.resolver(namehash);
        require(resolverAddress != address(0), "No resolver found");
        
        address resolvedAddress = IAddrResolver(resolverAddress).addr(namehash);
        require(resolvedAddress != address(0), "No address set");
        
        // Send funds - user has no idea if this is correct or malicious
        (bool success, ) = resolvedAddress.call{value: msg.value}("");
        require(success, "Transfer failed");
        
        resolvedAddresses[namehash] = resolvedAddress;
        sentAmounts[namehash] = msg.value;
        fundsSent[namehash] = true;
        
        emit FundsSent(namehash, resolvedAddress, msg.value, false);
    }
    
    /**
     * @notice Verify if the resolved address matches PublicResolver
     * @dev This is what a security-conscious DApp SHOULD do
     * @param namehash The namehash to verify
     * @return isSafe True if resolved address matches PublicResolver
     * @return resolvedAddr The address from the resolver
     * @return publicResolverAddr The address from PublicResolver
     */
    function verifyResolvedAddress(bytes32 namehash) external view returns (
        bool isSafe,
        address resolvedAddr,
        address publicResolverAddr
    ) {
        // Get address from the name's resolver
        address resolverAddress = ens.resolver(namehash);
        if (resolverAddress == address(0)) {
            return (false, address(0), address(0));
        }
        
        resolvedAddr = IAddrResolver(resolverAddress).addr(namehash);
        
        // Get address from PublicResolver (the trusted resolver)
        (bool success, bytes memory data) = MAINNET_PUBLIC_RESOLVER.staticcall(
            abi.encodeWithSignature("addr(bytes32)", namehash)
        );
        
        if (success && data.length > 0) {
            publicResolverAddr = abi.decode(data, (address));
        }
        
        // Safe if resolver is PublicResolver OR addresses match
        isSafe = (resolverAddress == MAINNET_PUBLIC_RESOLVER) || 
                 (resolvedAddr == publicResolverAddr);
    }
    
    /**
     * @notice Get the resolved address for a namehash
     */
    function getResolvedAddress(bytes32 namehash) external view returns (address) {
        return resolvedAddresses[namehash];
    }
    
    /**
     * @notice Get the amount sent to a namehash
     */
    function getSentAmount(bytes32 namehash) external view returns (uint256) {
        return sentAmounts[namehash];
    }
    
    /**
     * @notice Check if funds were sent to a namehash
     */
    function wereFundsSent(bytes32 namehash) external view returns (bool) {
        return fundsSent[namehash];
    }
}
