# ENS Contracts Decomposition Summary

**Total Contracts Analyzed:** 33
**Total Source Files:** 395
**Total Lines of Code:** 40,724
**Total Functions:** 1478
**Contracts with Potential Issues:** 22

## Security Overview

- Contracts with Access Control: 13
- Contracts with Reentrancy Guards: 5
- Contracts with Low-Level Calls: 6
- Total Payable Functions: 22

## Top Dependencies

- `@openzeppelin/contracts/access/Ownable.sol`: 11 contracts
- `../registry/ENS.sol`: 10 contracts
- `../utils/Context.sol`: 9 contracts
- `./IERC165.sol`: 8 contracts
- `@openzeppelin/contracts/token/ERC721/IERC721.sol`: 7 contracts
- `@openzeppelin/contracts/utils/introspection/IERC165.sol`: 7 contracts
- `../../utils/introspection/IERC165.sol`: 6 contracts
- `../../utils/BytesUtils.sol`: 6 contracts
- `./IBaseRegistrar.sol`: 5 contracts
- `../utils/BytesUtils.sol`: 5 contracts

## Vulnerability Candidates

### BaseRegistrarImplementation
Address: `0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### DNSRegistrar
Address: `0xB32cB5677a7C971689228EC835800432B339bA2B`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### DNSSECImpl
Address: `0x0fc3152971714E5ed7723FAFa650F86A4BaF30C5`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### DefaultReverseRegistrar
Address: `0x283F227c4Bd38ecE252C4Ae7ECE650B0e913f1f9`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### DefaultReverseResolver
Address: `0xA7d635c8de9a58a228AA69353a1699C7Cc240DCF`

- Contains inline assembly

### ETHRegistrarController
Address: `0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547`

- Contains selfdestruct
- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### ExponentialPremiumPriceOracle
Address: `0x7542565191d074cE84fBfA92cAE13AcB84788CA9`

- Uses block.timestamp (timestamp dependency)

### ExtendedDNSResolver
Address: `0x08769D484a7Cd9c4A98E928D9E270221F3E8578c`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### NameWrapper
Address: `0xD4416b13d2b3a9aBae7AcD5D6C2BbDBE25686401`

- Uses tx.origin (security risk)
- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### OffchainDNSResolver
Address: `0xF142B308cF687d4358410a4cB885513b30A42025`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### P256SHA256Algorithm
Address: `0x0faa24e538bA4620165933f68a9d142f79A68091`

- Contains inline assembly

### PublicResolver
Address: `0xF29100983E058B709F3D539b0c765937B804AC15`

- Contains inline assembly

### RSASHA1Algorithm
Address: `0x6ca8624Bc207F043D140125486De0f7E624e37A1`

- Contains inline assembly

### RSASHA256Algorithm
Address: `0x9D1B5a639597f558bC37Cf81813724076c5C1e96`

- Contains inline assembly

### ReverseRegistrar
Address: `0xa58E81fe9b61B5c3fE2AFD33CF304c454AbFc7Cb`

- Contains inline assembly

### SHA1Digest
Address: `0x9c9fcEa62bD0A723b62A2F1e98dE0Ee3df813619`

- Contains inline assembly

### SHA1NSEC3Digest
Address: `0x849851A7683cfF52De5F50C712C0606FEf6A3e8f`

- Contains inline assembly

### SHA256Digest
Address: `0xCFe6edBD47a032585834A6921D1d05CB70FcC36d`

- Contains inline assembly

### StaticBulkRenewal
Address: `0xc649947a460B135e6B9a70Ee2FB429aDBB529290`

- Contains selfdestruct
- Uses block.timestamp (timestamp dependency)
- Contains inline assembly

### TLDPublicSuffixList
Address: `0x7A72fEFd970A7726c4823623d88E9f3eFA1c300C`

- Contains inline assembly

### UniversalResolver
Address: `0xED73a03F19e8D849E44a39252d222c6ad5217E1e`

- Contains inline assembly

### WrappedETHRegistrarController
Address: `0x253553366Da8546fC250F225fe3d25d0C782303b`

- Uses block.timestamp (timestamp dependency)
- Contains inline assembly


## Contract Details

### ArbitrumReverseResolver
- Address: `N/A`
- Source Files: 0
- Functions: 0
- Potential Issues: 0

### BaseRegistrarImplementation
- Address: `0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85`
- Source Files: 3
- Functions: 47
- Potential Issues: 2

### BaseReverseResolver
- Address: `N/A`
- Source Files: 0
- Functions: 0
- Potential Issues: 0

### BatchGatewayProvider
- Address: `0xd1E3FAc3837b85437530B8B5244E4deF43219C04`
- Source Files: 4
- Functions: 10
- Potential Issues: 0

### DNSRegistrar
- Address: `0xB32cB5677a7C971689228EC835800432B339bA2B`
- Source Files: 24
- Functions: 85
- Potential Issues: 2

### DNSSECImpl
- Address: `0x0fc3152971714E5ed7723FAFa650F86A4BaF30C5`
- Source Files: 9
- Functions: 52
- Potential Issues: 2

### DefaultReverseRegistrar
- Address: `0x283F227c4Bd38ecE252C4Ae7ECE650B0e913f1f9`
- Source Files: 22
- Functions: 120
- Potential Issues: 2

### DefaultReverseResolver
- Address: `0xA7d635c8de9a58a228AA69353a1699C7Cc240DCF`
- Source Files: 14
- Functions: 27
- Potential Issues: 1

### ENSRegistry
- Address: `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`
- Source Files: 3
- Functions: 14
- Potential Issues: 0

### ETHRegistrarController
- Address: `0x59E16fcCd424Cc24e280Be16E11Bcd56fb0CE547`
- Source Files: 36
- Functions: 123
- Potential Issues: 3

### ExponentialPremiumPriceOracle
- Address: `0x7542565191d074cE84fBfA92cAE13AcB84788CA9`
- Source Files: 8
- Functions: 17
- Potential Issues: 1

### ExtendedDNSResolver
- Address: `0x08769D484a7Cd9c4A98E928D9E270221F3E8578c`
- Source Files: 12
- Functions: 42
- Potential Issues: 2

### LineaReverseResolver
- Address: `N/A`
- Source Files: 0
- Functions: 0
- Potential Issues: 0

### MigrationHelper
- Address: `0xeA6407e845Bf7a462FBdb3584728a9f617dA7FE9`
- Source Files: 13
- Functions: 61
- Potential Issues: 0

### NameWrapper
- Address: `0xD4416b13d2b3a9aBae7AcD5D6C2BbDBE25686401`
- Source Files: 27
- Functions: 112
- Potential Issues: 3

### OffchainDNSResolver
- Address: `0xF142B308cF687d4358410a4cB885513b30A42025`
- Source Files: 16
- Functions: 81
- Potential Issues: 2

### OptimismReverseResolver
- Address: `N/A`
- Source Files: 0
- Functions: 0
- Potential Issues: 0

### P256SHA256Algorithm
- Address: `0x0faa24e538bA4620165933f68a9d142f79A68091`
- Source Files: 5
- Functions: 33
- Potential Issues: 1

### PublicResolver
- Address: `0xF29100983E058B709F3D539b0c765937B804AC15`
- Source Files: 42
- Functions: 141
- Potential Issues: 1

### RSASHA1Algorithm
- Address: `0x6ca8624Bc207F043D140125486De0f7E624e37A1`
- Source Files: 7
- Functions: 18
- Potential Issues: 1

### RSASHA256Algorithm
- Address: `0x9D1B5a639597f558bC37Cf81813724076c5C1e96`
- Source Files: 6
- Functions: 16
- Potential Issues: 1

### ReverseRegistrar
- Address: `0xa58E81fe9b61B5c3fE2AFD33CF304c454AbFc7Cb`
- Source Files: 14
- Functions: 36
- Potential Issues: 1

### Root
- Address: `0xaB528d626EC275E3faD363fF1393A41F581c5897`
- Source Files: 2
- Functions: 17
- Potential Issues: 0

### SHA1Digest
- Address: `0x9c9fcEa62bD0A723b62A2F1e98dE0Ee3df813619`
- Source Files: 5
- Functions: 16
- Potential Issues: 1

### SHA1NSEC3Digest
- Address: `0x849851A7683cfF52De5F50C712C0606FEf6A3e8f`
- Source Files: 4
- Functions: 17
- Potential Issues: 1

### SHA256Digest
- Address: `0xCFe6edBD47a032585834A6921D1d05CB70FcC36d`
- Source Files: 4
- Functions: 14
- Potential Issues: 1

### ScrollReverseResolver
- Address: `N/A`
- Source Files: 0
- Functions: 0
- Potential Issues: 0

### SimplePublicSuffixList
- Address: `0x823BDa9cA8c47d072376eCD595530c8fb2fAa3ED`
- Source Files: 4
- Functions: 4
- Potential Issues: 0

### StaticBulkRenewal
- Address: `0xc649947a460B135e6B9a70Ee2FB429aDBB529290`
- Source Files: 38
- Functions: 124
- Potential Issues: 3

### StaticMetadataService
- Address: `0x3A368e3D5F19aF3DE594A9fC2CFfc6e256a616c7`
- Source Files: 2
- Functions: 1
- Potential Issues: 0

### TLDPublicSuffixList
- Address: `0x7A72fEFd970A7726c4823623d88E9f3eFA1c300C`
- Source Files: 4
- Functions: 14
- Potential Issues: 1

### UniversalResolver
- Address: `0xED73a03F19e8D849E44a39252d222c6ad5217E1e`
- Source Files: 27
- Functions: 92
- Potential Issues: 1

### WrappedETHRegistrarController
- Address: `0x253553366Da8546fC250F225fe3d25d0C782303b`
- Source Files: 40
- Functions: 144
- Potential Issues: 2

