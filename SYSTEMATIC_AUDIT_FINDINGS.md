# ENS Systematic Audit Findings

**Date:** 2026-02-09  
**Scope:** ENS deployed contracts + staging branch  
**Auditor:** Automated systematic review  

---

## Summary

After thorough review of all 7 deployed contracts and the staging branch repo, **no critical exploitable vulnerabilities meeting the Immunefi bounty criteria were identified**. The contracts are well-designed with proper access controls, reentrancy protection (state-before-interaction patterns), and consistent cross-contract state management.

Below are the notable observations and medium/low severity findings discovered during the audit. These do **not** meet the threshold for the Immunefi bug bounty ($150K-$250K for critical smart contract vulnerabilities involving direct theft, permanent freezing, unauthorized minting, or domain hijacking).

---

## Findings

### Finding 1: Signature Replay in DefaultReverseRegistrar (Low-Medium)

**Contract:** DefaultReverseRegistrar (0x283F227c4Bd38ecE252C4Ae7ECE650B0e913f1f9)

**Vulnerable Code:**
```solidity
// contracts/reverseRegistrar/DefaultReverseRegistrar.sol
function setNameForAddrWithSignature(
    address addr,
    uint256 signatureExpiry,
    string calldata name,
    bytes calldata signature
) external {
    bytes32 message = keccak256(
        abi.encodePacked(
            address(this),
            this.setNameForAddrWithSignature.selector,
            addr,
            signatureExpiry,
            name
        )
    ).toEthSignedMessageHash();
    signature.validateSignatureWithExpiry(addr, message, signatureExpiry);
    _setName(addr, name);
}
```

**Issue:** No nonce is included in the signed message. A valid signature can be replayed unlimited times within the validity window (up to 1 hour, enforced by `SignatureExpiryTooHigh` in SignatureUtils).

**Attack Scenario:**
1. Alice signs a message to set her reverse name to "alice.eth"
2. Relayer submits the transaction
3. Alice subsequently calls `setName("newname.eth")` to update her reverse record
4. Attacker replays Alice's original signature (still within 1-hour window), reverting her name to "alice.eth"

**Impact:** Temporary denial of reverse record changes within a 1-hour window. An attacker who observes the original signature (e.g., from mempool or transaction history) can prevent a user from changing their default reverse record for up to 1 hour after signature creation. Not critical — the effect is temporary and doesn't enable fund theft, domain hijacking, or permanent state corruption.

**Severity:** Low-Medium. Limited time window and limited impact.

---

### Finding 2: Permissionless ETH Withdrawal Trigger (Informational)

**Contract:** ETHRegistrarController (0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547)

**Code:**
```solidity
function withdraw() public {
    payable(owner()).transfer(address(this).balance);
}
```

**Issue:** The `withdraw()` function has no access control — anyone can call it. Funds always go to `owner()`, so this cannot be exploited for fund theft. However, if the owner is a contract that cannot receive ETH via `transfer()` (2300 gas stipend), accumulated registration fees could become permanently locked.

**Impact:** Informational. No direct exploit, but could cause issues with certain owner contract types. The owner can be changed via `transferOwnership()`.

---

### Finding 3: Registration with Malicious Resolver Allows Temporary Reentrancy Window (Low)

**Contract:** ETHRegistrarController (0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547)

**Code:**
```solidity
// In register(), when resolver != address(0):
expires = base.register(uint256(labelhash), address(this), registration.duration);
ens.setRecord(namehash, registration.owner, registration.resolver, 0);

if (registration.data.length > 0)
    Resolver(registration.resolver).multicallWithNodeCheck(namehash, registration.data);

base.transferFrom(address(this), registration.owner, uint256(labelhash));
```

**Issue:** The `registration.resolver` is user-controlled. A malicious resolver contract could re-enter the controller during `multicallWithNodeCheck`. However, the reentrancy window is not exploitable because:
- The commitment is already deleted (can't re-register same name)
- New commitments require `minCommitmentAge` to pass (can't register other names)
- The controller holds the NFT but has no exploitable state
- `withdraw()` sends to `owner()`, not the attacker

**Impact:** None in practice. The reentrancy window exists but there's no exploitable path for fund theft or domain hijacking.

---

## Areas Reviewed Without Findings

### ETHRegistrarController (0x59E1...)
- ✅ Commitment front-running protection (secret included in hash)
- ✅ Commitment replay protection (deleted after use, unexpired check on commit)
- ✅ Price oracle integration (base + premium for registration, base only for renewal — by design)
- ✅ ETH refund logic (refunds excess correctly)
- ✅ Cross-contract state consistency (ENS record + NFT ownership aligned after registration)

### NameWrapper (0xD441...)
- ✅ Fuse burning logic (PCC + CU requirements enforced)
- ✅ ERC1155Fuse state-before-callback pattern (no reentrancy via safe transfer hooks)
- ✅ `_checkCanCallSetSubnodeOwner` correctly handles expired/unexpired/PCC scenarios
- ✅ Expiry normalization prevents expiry reduction
- ✅ `wrapETH2LD` / `unwrapETH2LD` properly syncs registrar + ENS registry + wrapper state
- ✅ `onERC721Received` validates labelhash matches label
- ✅ `upgrade()` properly burns token before calling upgrade contract

### PublicResolver (0xF291...)
- ✅ `isAuthorised` correctly checks trusted controller, ENS owner, NameWrapper owner, operators, and delegates
- ✅ Multicallable delegatecall to self is safe (preserves msg.sender, no storage conflicts)
- ✅ `multicallWithNodeCheck` properly validates node for each subcall (bytes 4-36)
- ✅ `recordVersions` properly isolates versioned storage

### UniversalResolver (0xED73...)
- ✅ CCIP-Read flow properly chains callbacks
- ✅ `detectEIP140` correctly identifies safe/unsafe contracts
- ✅ Batch gateway response validation (count matching)
- ✅ View-only functions — no state modification possible

### ReverseRegistrar (0xa58E...)
- ✅ `authorised` modifier correctly checks addr, controller, ENS approval, and contract ownership
- ✅ `ownsContract` uses try/catch for safe external call

### MigrationHelper (0xeA64...)
- ✅ Requires user approval on registrar/wrapper before migration is possible
- ✅ `onlyController` access control on migration functions
- ✅ `migrationTarget` only settable by owner

### NameCoder / BytesUtils (staging)
- ✅ DNS encoding/decoding validates label boundaries
- ✅ Dot-in-label check prevents DNS encoding attacks
- ✅ Bounds checking on all memory reads

---

## Conclusion

The ENS contract ecosystem demonstrates strong security practices:
1. **State-before-interaction pattern** consistently used across NameWrapper/ERC1155Fuse
2. **Commitment scheme** properly prevents front-running with secret + timing window
3. **Cross-contract state** between BaseRegistrar, ENS Registry, and NameWrapper is consistently maintained
4. **Access control** is properly layered (owner, controller, authorized modifier)
5. **Fuse system** correctly enforces permission restrictions with parent/child relationships

No vulnerabilities meeting the critical severity threshold for the Immunefi bug bounty were found.
