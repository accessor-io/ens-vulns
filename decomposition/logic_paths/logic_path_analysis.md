# Stringent Logic Path Discovery - ENS Contracts

## Summary

- **Total Conditionals Analyzed**: 660
- **Total Functions Analyzed**: 1727
- **Hidden Paths Found**: 747
- **State Transitions**: 9

## Complex Conditionals (High Risk)

### P256SHA256Algorithm - sources/contracts/dnssec-oracle/algorithms/EllipticCurve.sol
- **Condition**: `0 == x || x == p || 0 == y || y == p`
- **Complexity Score**: 37
- **Edge Cases**: None
- **Position**: Line ~138

### UniversalResolver - sources/contracts/utils/NameCoder.sol
- **Condition**: `parseHashed &&
            size == 66 &&
            name[offset + 1] == "[" &&
            name[nex`
- **Complexity Score**: 33
- **Edge Cases**: None
- **Position**: Line ~103

### DefaultReverseResolver - sources/contracts/utils/NameCoder.sol
- **Condition**: `len == 66 && name[idx] == "[" && name[newIdx - 1] == "]"`
- **Complexity Score**: 26
- **Edge Cases**: None
- **Position**: Line ~48

### P256SHA256Algorithm - sources/contracts/dnssec-oracle/algorithms/EllipticCurve.sol
- **Condition**: `rs[0] == 0 || rs[0] >= n || rs[1] == 0`
- **Complexity Score**: 26
- **Edge Cases**: Zero value check
- **Position**: Line ~392

### PublicResolver - sources/contracts/utils/NameCoder.sol
- **Condition**: `len == 66 && name[idx] == "[" && name[newIdx - 1] == "]"`
- **Complexity Score**: 26
- **Edge Cases**: None
- **Position**: Line ~48

### PublicResolver - sources/contracts/resolvers/profiles/InterfaceResolver.sol
- **Condition**: `!success || returnData.length < 32 || returnData[31] == 0`
- **Complexity Score**: 22
- **Edge Cases**: Zero value check, Length check - potential overflow
- **Position**: Line ~58

### PublicResolver - sources/contracts/resolvers/profiles/InterfaceResolver.sol
- **Condition**: `!success || returnData.length < 32 || returnData[31] == 0`
- **Complexity Score**: 22
- **Edge Cases**: Zero value check, Length check - potential overflow
- **Position**: Line ~66

### NameWrapper - source.sol
- **Condition**: `oldFuses & PARENT_CANNOT_CONTROL != 0 &&
            oldFuses | fuses != oldFuses`
- **Complexity Score**: 19
- **Edge Cases**: Zero value check
- **Position**: Line ~557

### NameWrapper - sources/contracts/wrapper/NameWrapper.sol
- **Condition**: `oldFuses & PARENT_CANNOT_CONTROL != 0 &&
            oldFuses | fuses != oldFuses`
- **Complexity Score**: 19
- **Edge Cases**: Zero value check
- **Position**: Line ~608

### NameWrapper - source.sol
- **Condition**: `!canExtendSubname && fuses & CAN_EXTEND_EXPIRY == 0`
- **Complexity Score**: 15
- **Edge Cases**: Zero value check
- **Position**: Line ~475

### NameWrapper - sources/contracts/wrapper/NameWrapper.sol
- **Condition**: `!canExtendSubname && fuses & CAN_EXTEND_EXPIRY == 0`
- **Complexity Score**: 15
- **Edge Cases**: Zero value check
- **Position**: Line ~520

### OffchainDNSResolver - source.sol
- **Condition**: `nameOrAddress[idx] == "0" && nameOrAddress[idx + 1] == "x"`
- **Complexity Score**: 15
- **Edge Cases**: None
- **Position**: Line ~204

### OffchainDNSResolver - sources/contracts/dnsregistrar/OffchainDNSResolver.sol
- **Condition**: `nameOrAddress[idx] == "0" && nameOrAddress[idx + 1] == "x"`
- **Complexity Score**: 15
- **Edge Cases**: None
- **Position**: Line ~212

### P256SHA256Algorithm - sources/contracts/dnssec-oracle/algorithms/EllipticCurve.sol
- **Condition**: `x0 == 0 && y0 == 0`
- **Complexity Score**: 15
- **Edge Cases**: Zero value check
- **Position**: Line ~128

### PublicResolver - source.sol
- **Condition**: `msg.sender == trustedETHController ||
            msg.sender == trustedReverseRegistrar`
- **Complexity Score**: 15
- **Edge Cases**: None
- **Position**: Line ~117

### PublicResolver - sources/contracts/resolvers/PublicResolver.sol
- **Condition**: `msg.sender == trustedETHController ||
            msg.sender == trustedReverseRegistrar`
- **Complexity Score**: 15
- **Edge Cases**: None
- **Position**: Line ~113

### UniversalResolver - sources/contracts/ccipRead/CCIPBatcher.sol
- **Condition**: `!ok || v.length == 0`
- **Complexity Score**: 13
- **Edge Cases**: Zero value check, Length check - potential overflow
- **Position**: Line ~167

### DefaultReverseResolver - sources/contracts/utils/HexUtils.sol
- **Condition**: `nibbles > 64 || end > hexString.length`
- **Complexity Score**: 11
- **Edge Cases**: Length check - potential overflow
- **Position**: Line ~19

### PublicResolver - sources/contracts/utils/HexUtils.sol
- **Condition**: `nibbles > 64 || end > hexString.length`
- **Complexity Score**: 11
- **Edge Cases**: Length check - potential overflow
- **Position**: Line ~19

### UniversalResolver - sources/contracts/utils/HexUtils.sol
- **Condition**: `nibbles > 64 || end > hexString.length`
- **Complexity Score**: 11
- **Edge Cases**: Length check - potential overflow
- **Position**: Line ~20

## High Complexity Functions

### ExtendedDNSResolver::_findValue
- **File**: `source.sol`
- **Cyclomatic Complexity**: 43
- **Rating**: VERY_HIGH
- **Estimated Paths**: 8388608
- **External Calls**: 0
- **State Changes**: 45
- **Unusual Patterns**: multiple_returns, deep_nesting

### ExtendedDNSResolver::_findValue
- **File**: `sources/contracts/resolvers/profiles/ExtendedDNSResolver.sol`
- **Cyclomatic Complexity**: 43
- **Rating**: VERY_HIGH
- **Estimated Paths**: 8388608
- **External Calls**: 0
- **State Changes**: 45
- **Unusual Patterns**: multiple_returns, deep_nesting

### OffchainDNSResolver::resolve
- **File**: `sources/contracts/dnsregistrar/OffchainDNSResolver.sol`
- **Cyclomatic Complexity**: 24
- **Rating**: VERY_HIGH
- **Estimated Paths**: 131072
- **External Calls**: 4
- **State Changes**: 25
- **Unusual Patterns**: multiple_returns, deep_nesting

### ExponentialPremiumPriceOracle::addFractionalPremium
- **File**: `source.sol`
- **Cyclomatic Complexity**: 17
- **Rating**: HIGH
- **Estimated Paths**: 65536
- **External Calls**: 0
- **State Changes**: 16

### ExponentialPremiumPriceOracle::addFractionalPremium
- **File**: `sources/contracts/ethregistrar/ExponentialPremiumPriceOracle.sol`
- **Cyclomatic Complexity**: 17
- **Rating**: HIGH
- **Estimated Paths**: 65536
- **External Calls**: 0
- **State Changes**: 16

### DefaultReverseRegistrar::sqrt
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Cyclomatic Complexity**: 15
- **Rating**: HIGH
- **Estimated Paths**: 256
- **External Calls**: 0
- **State Changes**: 11
- **Unusual Patterns**: unchecked_block

### DNSRegistrar::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### DNSSECImpl::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### DefaultReverseResolver::_resolveName
- **File**: `sources/contracts/reverseResolver/AbstractReverseResolver.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 8

### DefaultReverseResolver::resolve
- **File**: `sources/contracts/reverseResolver/AbstractReverseResolver.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 8

### ExtendedDNSResolver::base32HexDecodeWord
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### OffchainDNSResolver::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### P256SHA256Algorithm::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### PublicResolver::base32HexDecodeWord
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### RSASHA1Algorithm::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### RSASHA256Algorithm::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### SHA1Digest::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### SHA256Digest::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### TLDPublicSuffixList::base32HexDecodeWord
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 17

### UniversalResolver::ccipBatch
- **File**: `sources/contracts/ccipRead/CCIPBatcher.sol`
- **Cyclomatic Complexity**: 13
- **Rating**: HIGH
- **Estimated Paths**: 64
- **External Calls**: 0
- **State Changes**: 8
- **Unusual Patterns**: deep_nesting

## Hidden or Unused Code Paths

### BaseRegistrarImplementation
- **Type**: unused_function
- **File**: `source.sol`
- **Function**: `mul`
- **Risk**: Dead code or hidden functionality

### BaseRegistrarImplementation
- **Type**: unused_function
- **File**: `source.sol`
- **Function**: `div`
- **Risk**: Dead code or hidden functionality

### BaseRegistrarImplementation
- **Type**: unused_function
- **File**: `source.sol`
- **Function**: `mod`
- **Risk**: Dead code or hidden functionality

### BaseRegistrarImplementation
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### BaseRegistrarImplementation
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/BaseRegistrarImplementation.sol`
- **Risk**: May indicate incomplete implementation

### BaseRegistrarImplementation
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### BatchGatewayProvider
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/IGatewayProvider.sol`
- **Risk**: May indicate incomplete implementation

### BatchGatewayProvider
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/GatewayProvider.sol`
- **Risk**: May indicate incomplete implementation

### BatchGatewayProvider
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### BatchGatewayProvider
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### BatchGatewayProvider
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### BatchGatewayProvider
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Function**: `_contextSuffixLength`
- **Risk**: Dead code or hidden functionality

### BatchGatewayProvider
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToAddress`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/ResolverBase.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IVersionableResolver.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/AddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/dnsregistrar/IDNSRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/dnsregistrar/DNSRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnsregistrar/DNSClaimChecker.sol`
- **Function**: `getOwnerAddress`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/dnsregistrar/DNSClaimChecker.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENSRegistry.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/DNSSEC.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readSignedSet`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rrs`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `done`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `name`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rdata`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDNSKEY`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDS`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `isSubdomainOf`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `compareNames`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `serialNumberGte`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `fromBytes`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `truncate`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendUint8`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes20`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes32`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendInt`
- **Risk**: Dead code or hidden functionality

### DNSRegistrar
- **Type**: commented_code
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Risk**: May indicate incomplete implementation

### DNSSECImpl
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### DNSSECImpl
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/DNSSECImpl.sol`
- **Risk**: May indicate incomplete implementation

### DNSSECImpl
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/DNSSEC.sol`
- **Risk**: May indicate incomplete implementation

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readSignedSet`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rrs`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `done`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `name`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rdata`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDNSKEY`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDS`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `isSubdomainOf`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `compareNames`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `serialNumberGte`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Risk**: May indicate incomplete implementation

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `fromBytes`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `truncate`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendUint8`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes20`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes32`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendInt`
- **Risk**: Dead code or hidden functionality

### DNSSECImpl
- **Type**: commented_code
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/reverseRegistrar/SignatureUtils.sol`
- **Function**: `validateSignatureWithExpiry`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/SignatureUtils.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IDefaultReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/DefaultReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/reverseRegistrar/StandaloneReverseRegistrar.sol`
- **Function**: `_setName`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/StandaloneReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IStandaloneReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/Panic.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Function**: `_contextSuffixLength`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Strings.sol`
- **Function**: `toStringSigned`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Strings.sol`
- **Function**: `toChecksumHexString`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/Strings.sol`
- **Function**: `equal`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/Strings.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/cryptography/ECDSA.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/cryptography/SignatureChecker.sol`
- **Function**: `isValidSignatureNow`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/cryptography/SignatureChecker.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/cryptography/MessageHashUtils.sol`
- **Function**: `toDataWithIntendedValidatorHash`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/cryptography/MessageHashUtils.sol`
- **Function**: `toTypedDataHash`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/cryptography/MessageHashUtils.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SignedMath.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SignedMath.sol`
- **Function**: `min`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SignedMath.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SignedMath.sol`
- **Function**: `abs`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SignedMath.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `tryAdd`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `trySub`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `tryMul`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `tryDiv`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `tryMod`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `min`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `ceilDiv`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `invMod`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Function**: `invModPrime`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/Math.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint248`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint240`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint232`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint224`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint216`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint208`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint200`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint192`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint184`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint176`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint168`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint160`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint152`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint144`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint136`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint128`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint120`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint112`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint104`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint96`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint88`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint80`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint72`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint64`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint56`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint48`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint40`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint32`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint24`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint16`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint8`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint256`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt248`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt240`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt232`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt224`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt216`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt208`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt200`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt192`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt184`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt176`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt168`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt160`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt152`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt144`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt136`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt128`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt120`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt112`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt104`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt96`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt88`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt80`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt72`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt64`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt56`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt48`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt40`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt32`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt24`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt16`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt8`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toInt256`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Function**: `toUint`
- **Risk**: Dead code or hidden functionality

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/math/SafeCast.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/interfaces/IERC1271.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/reverseResolver/DefaultReverseResolver.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/reverseResolver/AbstractReverseResolver.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/reverseResolver/INameReverser.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `isEVMCoinType`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `reverseName`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `parse`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Function**: `decode`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Function**: `encode`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToAddress`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToBytes`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `addressToHex`
- **Risk**: Dead code or hidden functionality

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedResolver.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/INameResolver.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IStandaloneReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### DefaultReverseResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts-v5/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### ENSRegistry
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### ENSRegistry
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENSRegistry.sol`
- **Risk**: May indicate incomplete implementation

### ENSRegistry
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENSRegistryWithFallback.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/utils/ERC20Recoverable.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/contracts/utils/StringUtils.sol`
- **Function**: `strlen`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/contracts/utils/StringUtils.sol`
- **Function**: `escape`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/utils/StringUtils.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IETHRegistrarController.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/ETHRegistrarController.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IPriceOracle.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/BaseRegistrarImplementation.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/Resolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IPubkeyResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ITextResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/INameResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSZoneResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IContentHashResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSRecordResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IABIResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IInterfaceResolver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IDefaultReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC20/IERC20.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Function**: `_burn`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Function**: `__unsafe_increaseBalance`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `sendValue`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `verifyCallResult`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Function**: `equal`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `min`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `abs`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Risk**: May indicate incomplete implementation

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `ceilDiv`
- **Risk**: Dead code or hidden functionality

### ETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: unused_function
- **File**: `source.sol`
- **Function**: `_premium`
- **Risk**: Dead code or hidden functionality

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: unused_function
- **File**: `sources/contracts/ethregistrar/StablePriceOracle.sol`
- **Function**: `weiToAttoUSD`
- **Risk**: Dead code or hidden functionality

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/StablePriceOracle.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IPriceOracle.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: unused_function
- **File**: `sources/contracts/ethregistrar/ExponentialPremiumPriceOracle.sol`
- **Function**: `_premium`
- **Risk**: Dead code or hidden functionality

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/ExponentialPremiumPriceOracle.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: unused_function
- **File**: `sources/contracts/ethregistrar/StringUtils.sol`
- **Function**: `strlen`
- **Risk**: Dead code or hidden functionality

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### ExponentialPremiumPriceOracle
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### ExponentialPremiumPriceOracle
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToAddress`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `addressToHex`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ExtendedDNSResolver.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ITextResolver.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedDNSResolver.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Function**: `equal`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `min`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `abs`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Risk**: May indicate incomplete implementation

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `ceilDiv`
- **Risk**: Dead code or hidden functionality

### ExtendedDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapper.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapperUpgrade.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/IMetadataService.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/Controllable.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/utils/MigrationHelper.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC1155/IERC1155.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### MigrationHelper
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### MigrationHelper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: unused_function
- **File**: `source.sol`
- **Function**: `_beforeTransfer`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapper.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapperUpgrade.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: unused_function
- **File**: `sources/contracts/wrapper/NameWrapper.sol`
- **Function**: `_beforeTransfer`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/NameWrapper.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/IMetadataService.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: unused_function
- **File**: `sources/contracts/wrapper/ERC1155Fuse.sol`
- **Function**: `_mint`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: unused_function
- **File**: `sources/contracts/wrapper/ERC1155Fuse.sol`
- **Function**: `_burn`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/ERC1155Fuse.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/Controllable.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/mocks/UpgradedNameWrapperMock.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/test/TestNameWrapperReentrancy.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/utils/ERC20Recoverable.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/mocks/DummyNameWrapper.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC20/IERC20.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC1155/IERC1155.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `sendValue`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `verifyCallResult`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### NameWrapper
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/LowLevelCallUtils.sol`
- **Function**: `functionStaticCall`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/LowLevelCallUtils.sol`
- **Function**: `returnDataSize`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/LowLevelCallUtils.sol`
- **Function**: `readReturnData`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/LowLevelCallUtils.sol`
- **Function**: `propagateRevert`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/LowLevelCallUtils.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToAddress`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedResolver.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedDNSResolver.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/dnsregistrar/OffchainDNSResolver.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENSRegistry.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/DNSSEC.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readSignedSet`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rrs`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `done`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `name`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rdata`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDNSKEY`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDS`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `isSubdomainOf`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `compareNames`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `serialNumberGte`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `sendValue`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `verifyCallResult`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `fromBytes`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `truncate`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendUint8`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes20`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes32`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendInt`
- **Risk**: Dead code or hidden functionality

### OffchainDNSResolver
- **Type**: commented_code
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Risk**: May indicate incomplete implementation

### P256SHA256Algorithm
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/algorithms/EllipticCurve.sol`
- **Function**: `multiplyPowerBase2`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/algorithms/EllipticCurve.sol`
- **Function**: `multipleGeneratorByScalar`
- **Risk**: Dead code or hidden functionality

### P256SHA256Algorithm
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/algorithms/EllipticCurve.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `source.sol`
- **Function**: `isAuthorised`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapper.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapperUpgrade.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/IMetadataService.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `isEVMCoinType`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `reverseName`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `parse`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Function**: `decode`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Function**: `encode`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToAddress`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToBytes`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `addressToHex`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/IMulticallable.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/ResolverBase.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/Multicallable.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/resolvers/PublicResolver.sol`
- **Function**: `isAuthorised`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/PublicResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IPubkeyResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/DNSResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IVersionableResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/TextResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ContentHashResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/PubkeyResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ITextResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/NameResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/INameResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSZoneResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/InterfaceResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ABIResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IContentHashResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IHasAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/AddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSRecordResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IABIResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IInterfaceResolver.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readSignedSet`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rrs`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `done`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `name`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `rdata`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDNSKEY`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `readDS`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `isSubdomainOf`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `compareNames`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Function**: `serialNumberGte`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/RRUtils.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC1155/IERC1155.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### PublicResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `fromBytes`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `truncate`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendUint8`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes20`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes32`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendInt`
- **Risk**: Dead code or hidden functionality

### PublicResolver
- **Type**: commented_code
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Risk**: May indicate incomplete implementation

### RSASHA1Algorithm
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/algorithms/RSAVerify.sol`
- **Function**: `rsarecover`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/algorithms/ModexpPrecompile.sol`
- **Function**: `modexp`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: unused_function
- **File**: `sources/@ensdomains/solsha1/contracts/SHA1.sol`
- **Function**: `sha1`
- **Risk**: Dead code or hidden functionality

### RSASHA1Algorithm
- **Type**: commented_code
- **File**: `sources/@ensdomains/solsha1/contracts/SHA1.sol`
- **Risk**: May indicate incomplete implementation

### RSASHA256Algorithm
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/algorithms/RSAVerify.sol`
- **Function**: `rsarecover`
- **Risk**: Dead code or hidden functionality

### RSASHA256Algorithm
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/algorithms/ModexpPrecompile.sol`
- **Function**: `modexp`
- **Risk**: Dead code or hidden functionality

### ReverseRegistrar
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/ReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IDefaultReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/DefaultReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IL2ReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/L2ReverseRegistrarWithMigration.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/L2ReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: unused_function
- **File**: `sources/contracts/reverseRegistrar/StandaloneReverseRegistrar.sol`
- **Function**: `_setName`
- **Risk**: Dead code or hidden functionality

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/StandaloneReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IStandaloneReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### ReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### ReverseRegistrar
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### ReverseRegistrar
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### Root
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### SHA1Digest
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### SHA1Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/solsha1/contracts/SHA1.sol`
- **Function**: `sha1`
- **Risk**: Dead code or hidden functionality

### SHA1Digest
- **Type**: commented_code
- **File**: `sources/@ensdomains/solsha1/contracts/SHA1.sol`
- **Risk**: May indicate incomplete implementation

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/SHA1.sol`
- **Function**: `sha1`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/SHA1.sol`
- **Risk**: May indicate incomplete implementation

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `fromBytes`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `truncate`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendUint8`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `writeBytes20`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes20`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendBytes32`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: unused_function
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Function**: `appendInt`
- **Risk**: Dead code or hidden functionality

### SHA1NSEC3Digest
- **Type**: commented_code
- **File**: `sources/@ensdomains/buffer/contracts/Buffer.sol`
- **Risk**: May indicate incomplete implementation

### SHA256Digest
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### SHA256Digest
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### SimplePublicSuffixList
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/utils/ERC20Recoverable.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/contracts/utils/StringUtils.sol`
- **Function**: `strlen`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/contracts/utils/StringUtils.sol`
- **Function**: `escape`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/utils/StringUtils.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IETHRegistrarController.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/ETHRegistrarController.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IPriceOracle.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/BaseRegistrarImplementation.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBulkRenewal.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/StaticBulkRenewal.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/Resolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IPubkeyResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ITextResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/INameResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSZoneResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IContentHashResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSRecordResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IABIResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IInterfaceResolver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/IDefaultReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC20/IERC20.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Function**: `_burn`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Function**: `__unsafe_increaseBalance`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `sendValue`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `verifyCallResult`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Function**: `equal`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `min`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Function**: `abs`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/SignedMath.sol`
- **Risk**: May indicate incomplete implementation

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `ceilDiv`
- **Risk**: Dead code or hidden functionality

### StaticBulkRenewal
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Risk**: May indicate incomplete implementation

### StaticMetadataService
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### StaticMetadataService
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/StaticMetadataService.sol`
- **Risk**: May indicate incomplete implementation

### TLDPublicSuffixList
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `base32HexDecodeWord`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: unused_function
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### TLDPublicSuffixList
- **Type**: commented_code
- **File**: `sources/contracts/dnssec-oracle/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `source.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `isEVMCoinType`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `reverseName`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Function**: `parse`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/ENSIP19.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/IFeatureSupporter.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint8`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint16`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readUint32`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytes20`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytes32`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `readBytesN`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `substring`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Function**: `find`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/BytesUtils.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Function**: `prevLabel`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Function**: `decode`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/NameCoder.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToAddress`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `hexToBytes`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Function**: `addressToHex`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/utils/HexUtils.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/IMulticallable.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/INameResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/universalResolver/RegistryUtils.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/universalResolver/AbstractUniversalResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/universalResolver/UniversalResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/universalResolver/IUniversalResolver.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/EIP3668.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/contracts/ccipRead/CCIPBatcher.sol`
- **Function**: `createBatch`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/CCIPBatcher.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/IBatchGateway.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/IGatewayProvider.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/contracts/ccipRead/CCIPReader.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol`
- **Function**: `supportsInterface`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol`
- **Function**: `getSupportedInterfaces`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol`
- **Function**: `supportsAllInterfaces`
- **Risk**: Dead code or hidden functionality

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165Checker.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### UniversalResolver
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapper.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/INameWrapperUpgrade.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/wrapper/IMetadataService.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/utils/ERC20Recoverable.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IETHRegistrarController.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/ETHRegistrarController.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IPriceOracle.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/contracts/ethregistrar/StringUtils.sol`
- **Function**: `strlen`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/BaseRegistrarImplementation.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/ethregistrar/IBaseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/Resolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IPubkeyResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IExtendedResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/ITextResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/INameResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSZoneResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddressResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IContentHashResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IAddrResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IDNSRecordResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IABIResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/resolvers/profiles/IInterfaceResolver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/registry/ENS.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/contracts/reverseRegistrar/ReverseRegistrar.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC20/IERC20.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Function**: `_burn`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/ERC721.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/IERC721.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/token/ERC1155/IERC1155.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/access/Ownable.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `sendValue`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Function**: `verifyCallResult`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Address.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgSender`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Function**: `_msgData`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Context.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Function**: `toString`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/Strings.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/ERC165.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/introspection/IERC165.sol`
- **Risk**: May indicate incomplete implementation

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `max`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `average`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: unused_function
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Function**: `ceilDiv`
- **Risk**: Dead code or hidden functionality

### WrappedETHRegistrarController
- **Type**: commented_code
- **File**: `sources/@openzeppelin/contracts/utils/math/Math.sol`
- **Risk**: May indicate incomplete implementation

## Complex State Transitions

### ExponentialPremiumPriceOracle::latestAnswer
- **Modified State Variables**: price1Letter, price2Letter, price3Letter, price4Letter, price5Letter, usdOracle
- **Complexity**: 6

