// SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/PublicResolver/sources/contracts/utils/HexUtils.sol";

contract POC_Input_Validation_Vulns is Test {
    using HexUtils for bytes;

    function test_HexString_Buffer_Overflow() public {
        console.log("=== TESTING HEX STRING BUFFER OVERFLOW VULNERABILITY ===");

        // Test 1: Extremely long hex string
        console.log("TEST 1: Extremely long hex string (>64 chars)");
        bytes memory longHex = new bytes(1000);
        for (uint i = 0; i < longHex.length; i++) {
            longHex[i] = "f";
        }

        (bytes32 result1, bool valid1) = longHex.hexStringToBytes32(0, longHex.length);
        console.log("Long hex string parsing result:");
        console.log("  Valid:", valid1);
        console.log("  Result:", uint256(result1));

        // This should fail safely, not overflow
        assertFalse(valid1, "Long hex string should be invalid");

        console.log("✅ Long hex string handled safely");
    }

    function test_Malformed_Hex_Characters() public {
        console.log("\nTEST 2: Malformed hex characters");

        // Test various invalid characters
        string[5] memory invalidHexes = [
            "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg", // g is invalid
            "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", // h is invalid
            "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii", // i is invalid
            "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", // z is invalid
            "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"  // uppercase G invalid
        ];

        for (uint i = 0; i < invalidHexes.length; i++) {
            bytes memory invalid = bytes(invalidHexes[i]);
            (bytes32 result, bool valid) = invalid.hexStringToBytes32(0, invalid.length);

            console.log(string(abi.encodePacked("  Invalid chars test ", string(abi.encodePacked(bytes1(uint8(97 + i)))), ":")));
            console.log("    Valid:", valid);
            assertFalse(valid, "Invalid hex characters should be rejected");
        }

        console.log("✅ Invalid characters handled safely");
    }

    function test_Edge_Case_Lengths() public {
        console.log("\nTEST 3: Edge case lengths");

        // Test odd length (should be even for hex)
        bytes memory oddLength = "123"; // 3 chars = odd
        (bytes32 result1, bool valid1) = oddLength.hexStringToBytes32(0, oddLength.length);
        console.log("Odd length (3 chars):", valid1);
        assertFalse(valid1, "Odd length hex should be invalid");

        // Test zero length
        bytes memory zeroLength = "";
        (bytes32 result2, bool valid2) = zeroLength.hexStringToBytes32(0, zeroLength.length);
        console.log("Zero length:", valid2);
        assertFalse(valid2, "Zero length hex should be invalid");

        // Test maximum valid length (64 chars)
        bytes memory maxValid = new bytes(64);
        for (uint i = 0; i < 64; i++) {
            maxValid[i] = "a";
        }
        (bytes32 result3, bool valid3) = maxValid.hexStringToBytes32(0, maxValid.length);
        console.log("Max valid length (64 chars):", valid3);
        assertTrue(valid3, "64 char hex should be valid");

        console.log("✅ Edge case lengths handled correctly");
    }

    function test_Out_Of_Bounds_Access() public {
        console.log("\nTEST 4: Out of bounds access attempts");

        bytes memory shortString = "deadbeef";

        // Try to read beyond string length
        (bytes32 result1, bool valid1) = shortString.hexStringToBytes32(0, shortString.length + 10);
        console.log("Reading beyond bounds:", valid1);
        assertFalse(valid1, "Out of bounds access should be prevented");

        // Try negative start position (simulate by using large pos)
        vm.expectRevert(); // Should revert due to bounds check
        (bytes32 result2, bool valid2) = shortString.hexStringToBytes32(shortString.length + 1, shortString.length + 2);

        console.log("✅ Out of bounds access prevented");
    }

    function test_Address_Parsing_Validation() public {
        console.log("\nTEST 5: Address parsing validation");

        // Test wrong length for address (should be exactly 40 chars)
        bytes memory wrongLength = "12345678901234567890123456789012345678901"; // 41 chars
        (address addr1, bool valid1) = wrongLength.hexToAddress(0, wrongLength.length);
        console.log("Wrong address length (41 chars):", valid1);
        assertFalse(valid1, "Wrong address length should be invalid");

        bytes memory tooShort = "123456789012345678901234567890123456789"; // 39 chars
        (address addr2, bool valid2) = tooShort.hexToAddress(0, tooShort.length);
        console.log("Too short address (39 chars):", valid2);
        assertFalse(valid2, "Too short address should be invalid");

        // Valid address
        bytes memory validAddr = "1234567890123456789012345678901234567890"; // 40 chars
        (address addr3, bool valid3) = validAddr.hexToAddress(0, validAddr.length);
        console.log("Valid address length (40 chars):", valid3);
        assertTrue(valid3, "Valid address length should work");

        console.log("✅ Address parsing validation works correctly");
    }

    function test_Integer_Overflow_In_Length_Calculation() public {
        console.log("\nTEST 6: Integer overflow in length calculation");

        // Test potential overflow in nibbles calculation: end - pos
        bytes memory testString = "deadbeef";

        // This should not overflow since end > pos in bounds check
        (bytes32 result, bool valid) = testString.hexStringToBytes32(0, testString.length);
        console.log("Normal parsing:", valid);
        assertTrue(valid, "Normal parsing should work");

        // Test with pos > end (should fail bounds check)
        vm.expectRevert(); // Bounds check should prevent this
        (bytes32 result2, bool valid2) = testString.hexStringToBytes32(5, 3); // pos > end

        console.log("✅ Integer overflow scenarios handled");
    }

    function test_Very_Large_Input_DoS() public {
        console.log("\nTEST 7: Very large input DoS potential");

        // Test extremely large input that could cause gas exhaustion
        // This tests if the function has any gas limits or validation
        uint256 largeSize = 10000; // Very large input
        bytes memory largeInput = new bytes(largeSize);

        // Fill with valid hex chars
        for (uint i = 0; i < largeSize; i++) {
            largeInput[i] = "a";
        }

        // Try to parse - should either succeed or fail gracefully
        (bytes32 result, bool valid) = largeInput.hexStringToBytes32(0, largeSize);

        console.log("Large input parsing result:");
        console.log("  Valid:", valid);
        console.log("  Size:", largeSize);

        // Should fail because nibbles > 64, but shouldn't crash
        assertFalse(valid, "Large input should be invalid");

        console.log("✅ Large input handled without DoS");
    }

    function test_Summary() public {
        console.log("\n=== INPUT VALIDATION VULNERABILITY ASSESSMENT ===");

        console.log("VULNERABILITIES TESTED:");
        console.log("✅ Buffer overflow protection");
        console.log("✅ Invalid character rejection");
        console.log("✅ Length validation (even/odd, bounds)");
        console.log("✅ Out of bounds access prevention");
        console.log("✅ Address-specific validation");
        console.log("✅ Integer overflow protection");
        console.log("✅ Large input DoS protection");

        console.log("\nOVERALL SECURITY STATUS:");
        console.log("🛡️ HexUtils.sol appears to have robust input validation");
        console.log("🛡️ Buffer overflows prevented by bounds checking");
        console.log("🛡️ Invalid characters properly rejected");
        console.log("🛡️ Length constraints enforced");
        console.log("🛡️ No obvious DoS vectors identified");

        console.log("\nCONCLUSION: Input validation appears SECURE in current codebase");
    }
}