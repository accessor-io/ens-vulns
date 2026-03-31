// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Simplified ENS interface
interface IENS {
    function owner(bytes32 node) external view returns (address);
    function setOwner(bytes32 node, address owner) external;
}

// Simplified NameWrapper with the VULNERABLE _unwrap function
contract SimpleNameWrapper is ERC1155, Ownable {
    IENS public ens;

    mapping(bytes32 => address) public ensOwner; // Simplified ENS ownership tracking

    event NameUnwrapped(bytes32 node, address owner);

    constructor(address _ens) ERC1155("") {
        ens = IENS(_ens);
    }

    // VULNERABLE FUNCTION - External call before state update
    function unwrap(bytes32 node) external {
        require(balanceOf(msg.sender, uint256(node)) > 0, "Not owner");

        // CRITICAL VULNERABILITY: _burn() called BEFORE ens.setOwner()
        _burn(msg.sender, uint256(node), 1);      // ← EXTERNAL CALL FIRST
        ensOwner[node] = msg.sender;               // ← STATE UPDATE AFTER (TOO LATE)

        emit NameUnwrapped(node, msg.sender);
    }

    // Wrap a name (for testing)
    function wrap(bytes32 node) external {
        _mint(msg.sender, uint256(node), 1, "");
        ensOwner[node] = address(this); // Wrapped names owned by contract
    }

    // View functions
    function isWrapped(bytes32 node) external view returns (bool) {
        return ensOwner[node] == address(this);
    }

    function getENSOwner(bytes32 node) external view returns (address) {
        return ensOwner[node];
    }
}