#!/bin/bash

# ENS Delegatecall Vulnerability PoC Test Runner
# This script runs all proof-of-concept tests for the 30 attack vectors

echo "=========================================="
echo "ENS Delegatecall Vulnerability PoC Tests"
echo "=========================================="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to run a test and check result
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .t.sol)

    echo -e "${BLUE}Running: ${test_name}${NC}"

    # Run the test with verbose output
    if forge test --match-path "$test_file" -v --ffi; then
        echo -e "${GREEN}✓ PASSED: ${test_name}${NC}"
        echo
        return 0
    else
        echo -e "${RED}✗ FAILED: ${test_name}${NC}"
        echo
        return 1
    fi
}

# Function to run all tests
run_all_tests() {
    local total_tests=0
    local passed_tests=0
    local failed_tests=0

    echo "Running all PoC tests..."
    echo

    # Get all test files
    test_files=$(find poc_tests -name "*.t.sol" | sort)

    for test_file in $test_files; do
        ((total_tests++))
        if run_test "$test_file"; then
            ((passed_tests++))
        else
            ((failed_tests++))
        fi
    done

    # Summary
    echo "=========================================="
    echo "TEST SUMMARY"
    echo "=========================================="
    echo "Total Tests: $total_tests"
    echo -e "Passed: ${GREEN}$passed_tests${NC}"
    echo -e "Failed: ${RED}$failed_tests${NC}"

    if [ $failed_tests -eq 0 ]; then
        echo -e "${GREEN}All PoC tests completed successfully!${NC}"
        echo "Vulnerabilities confirmed - immediate mitigation required."
    else
        echo -e "${RED}Some tests failed - review output above.${NC}"
    fi
}

# Function to run specific test
run_specific_test() {
    local test_pattern=$1
    echo "Running test matching: $test_pattern"
    echo

    if forge test --match-path "poc_tests/*$test_pattern*" -v --ffi; then
        echo -e "${GREEN}Test completed${NC}"
    else
        echo -e "${RED}Test failed${NC}"
        exit 1
    fi
}

# Function to run with gas reporting
run_with_gas_report() {
    echo "Running tests with gas reporting..."
    echo

    forge test --match-path poc_tests/ --gas-report
}

# Function to show help
show_help() {
    echo "ENS Delegatecall Vulnerability PoC Test Runner"
    echo
    echo "Usage:"
    echo "  $0                    # Run all PoC tests"
    echo "  $0 <pattern>         # Run tests matching pattern"
    echo "  $0 --gas             # Run with gas reporting"
    echo "  $0 --help            # Show this help"
    echo
    echo "Examples:"
    echo "  $0 Path01             # Run Path 1 authorization bypass test"
    echo "  $0 Batch              # Run batch exploitation tests"
    echo "  $0 --gas              # Show gas usage for all tests"
    echo
    echo "Available test patterns:"
    ls poc_tests/*.t.sol | sed 's/poc_tests\/POC_//' | sed 's/\.t\.sol//' | while read line; do
        echo "  $line"
    done
}

# Main logic
case "$1" in
    "")
        run_all_tests
        ;;
    "--gas")
        run_with_gas_report
        ;;
    "--help"|"-h")
        show_help
        ;;
    *)
        run_specific_test "$1"
        ;;
esac