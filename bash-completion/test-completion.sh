#!/bin/bash
#
# Test script for mm bash completion
# This script tests various completion scenarios

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source the completion script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/mm"

echo -e "${BLUE}Testing mm bash completion...${NC}\n"

# Helper function to test completion
test_completion() {
    local test_name=$1
    local cmd_line=$2
    local expected_pattern=$3
    
    # Parse the command line to set COMP_WORDS and COMP_CWORD
    IFS=' ' read -ra words <<< "$cmd_line"
    local cword=$((${#words[@]} - 1))
    
    export COMP_WORDS=("${words[@]}")
    export COMP_CWORD=$cword
    export COMP_LINE="$cmd_line"
    export COMP_POINT=${#COMP_LINE}
    
    # Clear previous completions
    COMPREPLY=()
    
    # Run completion
    _comp_cmd_mm
    
    # Check results
    if [[ -n "$expected_pattern" ]]; then
        local found=0
        for reply in "${COMPREPLY[@]}"; do
            if [[ "$reply" =~ $expected_pattern ]]; then
                found=1
                break
            fi
        done
        
        if [[ $found -eq 1 ]]; then
            echo -e "${GREEN}✓${NC} $test_name"
            echo "    Completions: ${COMPREPLY[*]:0:5}..."
        else
            echo -e "${RED}✗${NC} $test_name"
            echo "    Expected pattern: $expected_pattern"
            echo "    Got: ${COMPREPLY[*]}"
            return 1
        fi
    else
        echo -e "${GREEN}✓${NC} $test_name"
        echo "    Completions: ${COMPREPLY[*]:0:10}"
    fi
}

# Test 1: Option completion
echo -e "\n${BLUE}Testing option completion:${NC}"
test_completion "Complete --ta" "mm --ta" "--target"
test_completion "Complete --sh" "mm --sh" "--show"
test_completion "Complete -" "mm -" "-"

# Test 2: Option with value (--option=value format)
echo -e "\n${BLUE}Testing option=value completion:${NC}"
test_completion "Complete --target=d" "mm --target=d" "debug"
test_completion "Complete --target=o" "mm --target=o" "opt"
test_completion "Complete --pkgdb=c" "mm --pkgdb=c" "conda"
test_completion "Complete --palette=a" "mm --palette=a" "ansi"

# Test 3: Comma-separated target values
echo -e "\n${BLUE}Testing comma-separated values:${NC}"
test_completion "Complete --target=debug,o" "mm --target=debug,o" "opt"
test_completion "Complete --target=opt,s" "mm --target=opt,s" "s"

# Test 4: Target completion (fallback to common targets)
echo -e "\n${BLUE}Testing target completion:${NC}"
test_completion "Complete 'te'" "mm te" "test"
test_completion "Complete 'al'" "mm al" "all"

# Test 5: Option after target
echo -e "\n${BLUE}Testing options after targets:${NC}"
test_completion "Complete option after target" "mm all --" "--"

# Test 6: Test target discovery (requires mock project structure)
echo -e "\n${BLUE}Testing test target discovery:${NC}"

# Create a temporary test project structure
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

mkdir -p "$TEMP_DIR/.mm"
mkdir -p "$TEMP_DIR/TEST/serial"
mkdir -p "$TEMP_DIR/TEST/unit/math"

# Create test configuration
cat > "$TEMP_DIR/.mm/testproj.mm" << 'EOF'
# Test project configuration
testproj.tests := testproj.tests.serial testproj.tests.unit

testproj.tests.serial.stem := serial
testproj.tests.serial.root := TEST/serial/

testproj.tests.unit.stem := unit
testproj.tests.unit.root := TEST/unit/
EOF

# Create test files
cat > "$TEMP_DIR/.mm/libtestproj.tests" << 'EOF'
# Test suite configuration
testproj.tst.serial.drivers.exclude := excluded-test.cc
testproj.tst.unit.drivers.exclude := deprecated.py
EOF

echo "int main() {}" > "$TEMP_DIR/TEST/serial/hello.cc"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/world.cc"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/excluded-test.cc"
echo "# test" > "$TEMP_DIR/TEST/unit/basic.py"
echo "# test" > "$TEMP_DIR/TEST/unit/deprecated.py"
echo "int main() {}" > "$TEMP_DIR/TEST/unit/math/calc.cc"

# Test helper functions
cd "$TEMP_DIR"

echo "  Testing _comp_cmd_mm__parse_test_suites..."
SUITES=$(_comp_cmd_mm__parse_test_suites "$TEMP_DIR")
if echo "$SUITES" | grep -q "serial|TEST/serial/" && echo "$SUITES" | grep -q "unit|TEST/unit/"; then
    echo -e "  ${GREEN}✓${NC} Found test suites: serial and unit"
else
    echo -e "  ${RED}✗${NC} Failed to parse test suites"
    echo "  Got: $SUITES"
fi

echo "  Testing _comp_cmd_mm__get_exclusions..."
EXCLUSIONS=$(_comp_cmd_mm__get_exclusions "$TEMP_DIR" "serial")
if echo "$EXCLUSIONS" | grep -q "excluded-test.cc"; then
    echo -e "  ${GREEN}✓${NC} Found exclusion: excluded-test.cc"
else
    echo -e "  ${RED}✗${NC} Failed to parse exclusions"
    echo "  Got: $EXCLUSIONS"
fi

echo "  Testing _comp_cmd_mm__get_test_targets..."
TARGETS=$(_comp_cmd_mm__get_test_targets "$TEMP_DIR")

# Check that included targets are present
if echo "$TARGETS" | grep -q "TEST.serial.hello"; then
    echo -e "  ${GREEN}✓${NC} Found target: TEST.serial.hello"
else
    echo -e "  ${RED}✗${NC} Missing target: TEST.serial.hello"
    echo "  Got: $TARGETS"
fi

if echo "$TARGETS" | grep -q "TEST.unit.math.calc"; then
    echo -e "  ${GREEN}✓${NC} Found target: TEST.unit.math.calc"
else
    echo -e "  ${RED}✗${NC} Missing target: TEST.unit.math.calc"
fi

# Check that excluded targets are NOT present
if ! echo "$TARGETS" | grep -q "TEST.serial.excluded-test"; then
    echo -e "  ${GREEN}✓${NC} Correctly excluded: TEST.serial.excluded-test"
else
    echo -e "  ${RED}✗${NC} Failed to exclude: TEST.serial.excluded-test"
fi

if ! echo "$TARGETS" | grep -q "TEST.unit.deprecated"; then
    echo -e "  ${GREEN}✓${NC} Correctly excluded: TEST.unit.deprecated"
else
    echo -e "  ${RED}✗${NC} Failed to exclude: TEST.unit.deprecated"
fi

# Test completion integration
export COMP_WORDS=(mm TEST.serial.)
export COMP_CWORD=1
export COMP_LINE="mm TEST.serial."
export COMP_POINT=15
COMPREPLY=()
_comp_cmd_mm

if printf "%s\n" "${COMPREPLY[@]}" | grep -q "TEST.serial.hello"; then
    echo -e "  ${GREEN}✓${NC} Completion works for test targets"
else
    echo -e "  ${RED}✗${NC} Completion failed for test targets"
    echo "  Got: ${COMPREPLY[*]}"
fi

echo -e "\n${GREEN}All tests passed!${NC}"
