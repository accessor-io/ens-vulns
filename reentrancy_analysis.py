#!/usr/bin/env python3
"""
Reentrancy analysis and test for ETHRegistrarController
Analyzes the reentrancy window and tests exploitability
"""

import json
from pathlib import Path

def analyze_reentrancy_flow():
    """Analyze the exact reentrancy flow in register() function."""
    
    print("=" * 60)
    print("ETHRegistrarController Reentrancy Analysis")
    print("=" * 60)
    print()
    
    print("Registration Flow (with resolver):")
    print("1. Price calculation and validation")
    print("2. Availability check")
    print("3. Commitment validation (age checks)")
    print("4. DELETE commitments[commitment]  <-- State Change 1")
    print("5. base.register(labelhash, address(this), duration)  <-- State Change 2")
    print("6. ens.setRecord(namehash, owner, resolver, 0)  <-- State Change 3")
    print("7. [REENTRANCY WINDOW OPENS]")
    print("8. Resolver(registration.resolver).multicallWithNodeCheck(...)  <-- EXTERNAL CALL")
    print("9. [REENTRANCY WINDOW CLOSES]")
    print("10. base.transferFrom(address(this), owner, labelhash)  <-- State Change 4")
    print("11. Reverse registrar calls (if requested)")
    print("12. Refund excess payment")
    print()
    
    print("Reentrancy Window Analysis:")
    print("- Window: Between line 308 (external call) and line 313 (NFT transfer)")
    print("- State at reentrancy point:")
    print("  * Commitment: DELETED")
    print("  * Name: REGISTERED to address(this)")
    print("  * NFT: NOT YET TRANSFERRED to owner")
    print()
    
    print("Attack Scenarios:")
    print()
    print("Scenario 1: Re-enter register() with same commitment")
    print("  - Commitment is deleted -> CommitmentNotFound error")
    print("  - Name is registered -> NameNotAvailable error")
    print("  - Result: REENTRANCY PREVENTED")
    print()
    
    print("Scenario 2: Re-enter register() with different commitment")
    print("  - Would need different registration parameters")
    print("  - But name is already registered -> NameNotAvailable error")
    print("  - Result: REENTRANCY PREVENTED")
    print()
    
    print("Scenario 3: Call other controller functions")
    print("  - commit(): Would work but useless")
    print("  - register(): Would fail (name registered)")
    print("  - renew(): Requires existing name (could work if name exists)")
    print("  - Other functions: Depends on access control")
    print("  - Result: LIMITED EXPLOITABILITY")
    print()
    
    print("Scenario 4: Manipulate state before NFT transfer")
    print("  - Name is registered to address(this)")
    print("  - Could potentially call ENS registry functions?")
    print("  - Could manipulate resolver records?")
    print("  - Result: NEEDS DEEPER ANALYSIS")
    print()
    
    print("Potential Exploits:")
    print()
    print("1. State Manipulation:")
    print("   - During reentrancy, name is owned by controller")
    print("   - Could malicious resolver manipulate ENS records?")
    print("   - Could it change resolver or other records?")
    print()
    
    print("2. Race Condition:")
    print("   - If multiple transactions in same block")
    print("   - Could exploit timing between state changes")
    print()
    
    print("3. Other Function Calls:")
    print("   - Could call renew() if name already exists?")
    print("   - Could call other public functions?")
    print()
    
    print("Mitigation Analysis:")
    print("- Commitment deletion prevents re-registration")
    print("- Name registration prevents availability")
    print("- But reentrancy window still exists")
    print("- Recommendation: Add ReentrancyGuard for defense in depth")
    print()
    
    return {
        "reentrancy_window": {
            "start": "Line 308 - External resolver call",
            "end": "Line 313 - NFT transfer",
            "duration": "Between external call and NFT transfer"
        },
        "state_at_reentrancy": {
            "commitment": "DELETED",
            "name_owner": "address(this)",
            "nft_owner": "address(this) (not yet transferred)"
        },
        "attack_scenarios": {
            "re_register_same": "PREVENTED - commitment deleted, name registered",
            "re_register_different": "PREVENTED - name already registered",
            "other_functions": "POSSIBLE - depends on function",
            "state_manipulation": "NEEDS ANALYSIS"
        },
        "risk_level": "LOW-MEDIUM",
        "recommendation": "Add ReentrancyGuard for defense in depth"
    }

def create_exploit_test():
    """Create a test to verify reentrancy exploitability."""
    
    test_code = """
// Reentrancy Exploit Test
// This test attempts to exploit the reentrancy window

pragma solidity ^0.8.17;

contract ReentrancyExploitTest {
    // Test 1: Can we re-enter register()?
    // Expected: NO - commitment deleted, name registered
    
    // Test 2: Can we call other functions during reentrancy?
    // Expected: MAYBE - depends on function
    
    // Test 3: Can we manipulate state before NFT transfer?
    // Expected: NEEDS TESTING
    
    // Test 4: Can we exploit the refund?
    // Expected: NO - refund happens after all state changes
}
"""
    
    return test_code

def main():
    """Main analysis function."""
    analysis = analyze_reentrancy_flow()
    
    # Save analysis
    output_file = Path("decomposition/reentrancy_analysis.json")
    with open(output_file, 'w') as f:
        json.dump(analysis, f, indent=2)
    
    # Create markdown report
    md_file = Path("decomposition/REENTRANCY_TEST_ANALYSIS.md")
    with open(md_file, 'w') as f:
        f.write("# ETHRegistrarController Reentrancy Test Analysis\n\n")
        f.write("## Reentrancy Window\n\n")
        f.write(f"- **Start**: {analysis['reentrancy_window']['start']}\n")
        f.write(f"- **End**: {analysis['reentrancy_window']['end']}\n")
        f.write(f"- **Duration**: {analysis['reentrancy_window']['duration']}\n\n")
        
        f.write("## State at Reentrancy Point\n\n")
        for key, value in analysis['state_at_reentrancy'].items():
            f.write(f"- **{key}**: {value}\n")
        f.write("\n")
        
        f.write("## Attack Scenarios\n\n")
        for scenario, result in analysis['attack_scenarios'].items():
            f.write(f"### {scenario.replace('_', ' ').title()}\n")
            f.write(f"**Result**: {result}\n\n")
        
        f.write("## Risk Assessment\n\n")
        f.write(f"- **Risk Level**: {analysis['risk_level']}\n")
        f.write(f"- **Recommendation**: {analysis['recommendation']}\n\n")
        
        f.write("## Test Results\n\n")
        f.write("### Test 1: Re-enter register() with same commitment\n")
        f.write("- **Expected**: FAIL - Commitment deleted\n")
        f.write("- **Status**: NEEDS TESTING\n\n")
        
        f.write("### Test 2: Re-enter register() with different commitment\n")
        f.write("- **Expected**: FAIL - Name already registered\n")
        f.write("- **Status**: NEEDS TESTING\n\n")
        
        f.write("### Test 3: Call other functions during reentrancy\n")
        f.write("- **Expected**: LIMITED - Depends on function\n")
        f.write("- **Status**: NEEDS TESTING\n\n")
        
        f.write("### Test 4: State manipulation before NFT transfer\n")
        f.write("- **Expected**: UNKNOWN - Needs deeper analysis\n")
        f.write("- **Status**: NEEDS TESTING\n\n")
    
    print(f"\nAnalysis saved to: {output_file}")
    print(f"Report saved to: {md_file}")

if __name__ == "__main__":
    main()



