# ETHRegistrarController Reentrancy Test Analysis

## Reentrancy Window

- **Start**: Line 308 - External resolver call
- **End**: Line 313 - NFT transfer
- **Duration**: Between external call and NFT transfer

## State at Reentrancy Point

- **commitment**: DELETED
- **name_owner**: address(this)
- **nft_owner**: address(this) (not yet transferred)

## Attack Scenarios

### Re Register Same
**Result**: PREVENTED - commitment deleted, name registered

### Re Register Different
**Result**: PREVENTED - name already registered

### Other Functions
**Result**: POSSIBLE - depends on function

### State Manipulation
**Result**: NEEDS ANALYSIS

## Risk Assessment

- **Risk Level**: LOW-MEDIUM
- **Recommendation**: Add ReentrancyGuard for defense in depth

## Test Results

### Test 1: Re-enter register() with same commitment
- **Expected**: FAIL - Commitment deleted
- **Status**: NEEDS TESTING

### Test 2: Re-enter register() with different commitment
- **Expected**: FAIL - Name already registered
- **Status**: NEEDS TESTING

### Test 3: Call other functions during reentrancy
- **Expected**: LIMITED - Depends on function
- **Status**: NEEDS TESTING

### Test 4: State manipulation before NFT transfer
- **Expected**: UNKNOWN - Needs deeper analysis
- **Status**: NEEDS TESTING

