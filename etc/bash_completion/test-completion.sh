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

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0

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
            : $((TESTS_PASSED += 1))
        else
            echo -e "${RED}✗${NC} $test_name"
            echo "    Expected pattern: $expected_pattern"
            echo "    Got: ${COMPREPLY[*]}"
            : $((TESTS_FAILED += 1))
        fi
    else
        echo -e "${GREEN}✓${NC} $test_name"
        echo "    Completions: ${COMPREPLY[*]:0:10}"
        : $((TESTS_PASSED += 1))
    fi
}

# Helper to test that a completion does NOT contain a pattern
test_completion_excludes() {
    local test_name=$1
    local cmd_line=$2
    local excluded_pattern=$3

    IFS=' ' read -ra words <<< "$cmd_line"
    local cword=$((${#words[@]} - 1))

    export COMP_WORDS=("${words[@]}")
    export COMP_CWORD=$cword
    export COMP_LINE="$cmd_line"
    export COMP_POINT=${#COMP_LINE}

    COMPREPLY=()
    _comp_cmd_mm

    local found=0
    for reply in "${COMPREPLY[@]}"; do
        if [[ "$reply" =~ $excluded_pattern ]]; then
            found=1
            break
        fi
    done

    if [[ $found -eq 0 ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        : $((TESTS_PASSED += 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "    Should NOT contain: $excluded_pattern"
        echo "    Got: ${COMPREPLY[*]}"
        : $((TESTS_FAILED += 1))
    fi
}

# =============================================================================
# Test 1: Option completion
# =============================================================================
echo -e "\n${BLUE}Testing option completion:${NC}"
test_completion "Complete --ta" "mm --ta" "--target"
test_completion "Complete --sh" "mm --sh" "--show"
test_completion "Complete -" "mm -" "-"
test_completion "Complete --he" "mm --he" "--help"
test_completion "Complete --ve" "mm --ve" "--version|--verbose"
test_completion "Complete --pr" "mm --pr" "--prefix"
test_completion "Complete --ru" "mm --ru" "--rules"

# =============================================================================
# Test 2: Option with value (--option=value format)
# =============================================================================
echo -e "\n${BLUE}Testing option=value completion:${NC}"
test_completion "Complete --target=d" "mm --target=d" "debug"
test_completion "Complete --target=o" "mm --target=o" "opt"
test_completion "Complete --pkgdb=c" "mm --pkgdb=c" "conda"
test_completion "Complete --palette=a" "mm --palette=a" "ansi"
test_completion "Complete --compilers=g" "mm --compilers=g" "gcc"

# =============================================================================
# Test 3: Comma-separated target values
# =============================================================================
echo -e "\n${BLUE}Testing comma-separated values:${NC}"
test_completion "Complete --target=debug,o" "mm --target=debug,o" "opt"
test_completion "Complete --target=opt,s" "mm --target=opt,s" "s"

# =============================================================================
# Test 4: Global target completion
# =============================================================================
echo -e "\n${BLUE}Testing global target completion:${NC}"
test_completion "Complete 'he'" "mm he" "help"
test_completion "Complete 'cl'" "mm cl" "clean"
test_completion "Complete 'ti'" "mm ti" "tidy"
test_completion "Complete 'te'" "mm te" "tests"
test_completion "Complete 'mm.'" "mm mm." "mm\\.info|mm\\.usage|mm\\.banner|mm\\.config"
test_completion "Complete 'builder.'" "mm builder." "builder\\.info"
test_completion "Complete 'platform'" "mm platform" "platform\\.info"
test_completion "Complete 'host'" "mm host" "host\\.info"
test_completion "Complete 'user'" "mm user" "user\\.info"
test_completion "Complete 'developer'" "mm developer" "developer\\.info"
test_completion "Complete 'compilers'" "mm compilers" "compilers\\.info"
test_completion "Complete 'languages'" "mm languages" "languages\\.info"
test_completion "Complete 'suffixes'" "mm suffixes" "suffixes\\.info"
test_completion "Complete 'targets'" "mm targets" "targets\\.info"
test_completion "Complete 'extern'" "mm extern" "extern\\.info"
test_completion "Complete 'projects'" "mm projects" "projects"
test_completion "Complete 'libraries'" "mm libraries" "libraries\\.info"
test_completion "Complete 'packages'" "mm packages" "packages\\.info"
test_completion "Complete 'extensions'" "mm extensions" "extensions\\.info"

# =============================================================================
# Test 5: Options after target
# =============================================================================
echo -e "\n${BLUE}Testing options after targets:${NC}"
test_completion "Complete option after target" "mm clean --" "--"

# =============================================================================
# Test 6: Target descriptions
# =============================================================================
echo -e "\n${BLUE}Testing target descriptions:${NC}"

check_description() {
    local target=$1
    local expected=$2
    local desc
    desc=$(_comp_cmd_mm__get_target_description "$target")

    if [[ -n "$desc" && "$desc" == *"$expected"* ]]; then
        echo -e "${GREEN}✓${NC} Description for '$target': $desc"
        : $((TESTS_PASSED += 1))
    else
        echo -e "${RED}✗${NC} Description for '$target'"
        echo "    Expected to contain: $expected"
        echo "    Got: $desc"
        : $((TESTS_FAILED += 1))
    fi
}

check_description "help" "usage"
check_description "clean" "Clean"
check_description "mm.info" "mm variables"
check_description "builder.info" "builder directory"
check_description "platform.info" "platform"
check_description "extern.info" "external package"
check_description "foo.dll" "shared library"
check_description "foo.archive" "static archive"
check_description "foo.pyc" "Byte-compile"
check_description "foo.testcases" "test cases"
check_description "foo.build" "docker build"
check_description "foo.launch" "interactively"

# =============================================================================
# Test 7: Project configuration parsing and asset target generation
# =============================================================================
echo -e "\n${BLUE}Testing project configuration parsing:${NC}"

# Create a temporary test project structure
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

mkdir -p "$TEMP_DIR/.mm"
mkdir -p "$TEMP_DIR/lib/hello"
mkdir -p "$TEMP_DIR/packages/hello"
mkdir -p "$TEMP_DIR/TEST/serial"
mkdir -p "$TEMP_DIR/TEST/unit/math"

# Create project configuration with multiple asset types
cat > "$TEMP_DIR/.mm/myproj.mm" << 'EOF'
# -*- Makefile -*-

# myproj builds a library
myproj.libraries := myproj.lib
# a python package
myproj.packages := myproj.pkg
# a python extension
myproj.extensions := myproj.ext
# and test suites
myproj.tests := myproj.tests.serial myproj.tests.unit

# library metadata
myproj.lib.stem := myproj
myproj.lib.root := lib/hello/

# package metadata
myproj.pkg.stem := myproj
myproj.pkg.root := packages/hello/

# extension metadata
myproj.ext.stem := myproj
myproj.ext.pkg := myproj.pkg
myproj.ext.wraps := myproj.lib

# test suite metadata
myproj.tests.serial.stem := serial
myproj.tests.serial.root := TEST/serial/

myproj.tests.unit.stem := unit
myproj.tests.unit.root := TEST/unit/

# test exclusions
myproj.tst.serial.drivers.exclude := excluded-test.cc
myproj.tst.unit.drivers.exclude := deprecated.py
EOF

# Create test files
echo "int main() {}" > "$TEMP_DIR/TEST/serial/hello.cc"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/world.cc"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/excluded-test.cc"
echo "# test" > "$TEMP_DIR/TEST/unit/basic.py"
echo "# test" > "$TEMP_DIR/TEST/unit/deprecated.py"
echo "int main() {}" > "$TEMP_DIR/TEST/unit/math/calc.cc"

cd "$TEMP_DIR"

# --- Test parse_assets ---
echo "  Testing _comp_cmd_mm__parse_assets..."
ASSETS=$(_comp_cmd_mm__parse_assets "$TEMP_DIR")

check_asset() {
    local expected=$1
    if echo "$ASSETS" | grep -q "^$expected$"; then
        echo -e "  ${GREEN}✓${NC} Found asset: $expected"
        : $((TESTS_PASSED += 1))
    else
        echo -e "  ${RED}✗${NC} Missing asset: $expected"
        echo "  All assets: $ASSETS"
        : $((TESTS_FAILED += 1))
    fi
}

check_asset "library|myproj.lib"
check_asset "package|myproj.pkg"
check_asset "extension|myproj.ext"
check_asset "testsuite|myproj.tests.serial"
check_asset "testsuite|myproj.tests.unit"

# --- Test get_project_names ---
echo ""
echo "  Testing _comp_cmd_mm__get_project_names..."
PROJ_NAMES=$(_comp_cmd_mm__get_project_names "$TEMP_DIR")
if echo "$PROJ_NAMES" | grep -q "myproj"; then
    echo -e "  ${GREEN}✓${NC} Found project: myproj"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Missing project: myproj"
    : $((TESTS_FAILED += 1))
fi

# --- Test get_all_targets generates per-asset suffixed targets ---
echo ""
echo "  Testing _comp_cmd_mm__get_all_targets generates suffixed targets..."
ALL_TARGETS=$(_comp_cmd_mm__get_all_targets)

check_target() {
    local target=$1
    if echo "$ALL_TARGETS" | tr ' ' '\n' | grep -q "^${target}$"; then
        echo -e "  ${GREEN}✓${NC} Found target: $target"
        : $((TESTS_PASSED += 1))
    else
        echo -e "  ${RED}✗${NC} Missing target: $target"
        : $((TESTS_FAILED += 1))
    fi
}

# Project targets
check_target "myproj"
check_target "myproj.info"
check_target "myproj.clean"
check_target "myproj.help"
check_target "myproj.assets"

# Library targets
check_target "myproj.lib"
check_target "myproj.lib.clean"
check_target "myproj.lib.archive"
check_target "myproj.lib.dll"
check_target "myproj.lib.headers"
check_target "myproj.lib.info"
check_target "myproj.lib.info.sources"
check_target "myproj.lib.info.headers"
check_target "myproj.lib.info.languages"
check_target "myproj.lib.help"

# Package targets
check_target "myproj.pkg"
check_target "myproj.pkg.clean"
check_target "myproj.pkg.pyc"
check_target "myproj.pkg.drivers"
check_target "myproj.pkg.info"
check_target "myproj.pkg.info.sources"
check_target "myproj.pkg.info.pyc"
check_target "myproj.pkg.help"

# Extension targets
check_target "myproj.ext"
check_target "myproj.ext.extension"
check_target "myproj.ext.clean"
check_target "myproj.ext.info"
check_target "myproj.ext.capsule"

# Test suite targets
check_target "myproj.tests.serial"
check_target "myproj.tests.serial.testcases"
check_target "myproj.tests.serial.clean"
check_target "myproj.tests.serial.info"
check_target "myproj.tests.serial.help"

check_target "myproj.tests.unit"
check_target "myproj.tests.unit.info.drivers"
check_target "myproj.tests.unit.info.staging.targets"

# Global targets
check_target "help"
check_target "clean"
check_target "tidy"
check_target "tests"
check_target "projects"
check_target "mm.info"
check_target "builder.info"
check_target "platform.info"
check_target "extern.info"

# =============================================================================
# Test 8: Test target discovery (filesystem scan)
# =============================================================================
echo -e "\n${BLUE}Testing test target discovery:${NC}"

echo "  Testing _comp_cmd_mm__parse_test_suites..."
SUITES=$(_comp_cmd_mm__parse_test_suites "$TEMP_DIR")
if echo "$SUITES" | grep -q "serial|TEST/serial/" && echo "$SUITES" | grep -q "unit|TEST/unit/"; then
    echo -e "  ${GREEN}✓${NC} Found test suites: serial and unit"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Failed to parse test suites"
    echo "  Got: $SUITES"
    : $((TESTS_FAILED += 1))
fi

echo "  Testing _comp_cmd_mm__get_exclusions..."
EXCLUSIONS=$(_comp_cmd_mm__get_exclusions "$TEMP_DIR" "serial")
if echo "$EXCLUSIONS" | grep -q "excluded-test.cc"; then
    echo -e "  ${GREEN}✓${NC} Found exclusion: excluded-test.cc"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Failed to parse exclusions"
    echo "  Got: $EXCLUSIONS"
    : $((TESTS_FAILED += 1))
fi

echo "  Testing _comp_cmd_mm__get_test_targets..."
TARGETS=$(_comp_cmd_mm__get_test_targets "$TEMP_DIR")

# Check that included targets are present
if echo "$TARGETS" | grep -q "TEST.serial.hello"; then
    echo -e "  ${GREEN}✓${NC} Found target: TEST.serial.hello"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Missing target: TEST.serial.hello"
    echo "  Got: $TARGETS"
    : $((TESTS_FAILED += 1))
fi

if echo "$TARGETS" | grep -q "TEST.unit.math.calc"; then
    echo -e "  ${GREEN}✓${NC} Found target: TEST.unit.math.calc"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Missing target: TEST.unit.math.calc"
    : $((TESTS_FAILED += 1))
fi

# Check that excluded targets are NOT present
if ! echo "$TARGETS" | grep -q "TEST.serial.excluded-test"; then
    echo -e "  ${GREEN}✓${NC} Correctly excluded: TEST.serial.excluded-test"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Failed to exclude: TEST.serial.excluded-test"
    : $((TESTS_FAILED += 1))
fi

if ! echo "$TARGETS" | grep -q "TEST.unit.deprecated"; then
    echo -e "  ${GREEN}✓${NC} Correctly excluded: TEST.unit.deprecated"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Failed to exclude: TEST.unit.deprecated"
    : $((TESTS_FAILED += 1))
fi

# =============================================================================
# Test 9: Completion integration with project context
# =============================================================================
echo -e "\n${BLUE}Testing completion integration with project context:${NC}"

export COMP_WORDS=(mm TEST.serial.)
export COMP_CWORD=1
export COMP_LINE="mm TEST.serial."
export COMP_POINT=15
COMPREPLY=()
_comp_cmd_mm

if printf "%s\n" "${COMPREPLY[@]}" | grep -q "TEST.serial.hello"; then
    echo -e "  ${GREEN}✓${NC} Completion works for test targets"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Completion failed for test targets"
    echo "  Got: ${COMPREPLY[*]}"
    : $((TESTS_FAILED += 1))
fi

# Test completing library targets
export COMP_WORDS=(mm myproj.lib.)
export COMP_CWORD=1
export COMP_LINE="mm myproj.lib."
export COMP_POINT=14
COMPREPLY=()
_comp_cmd_mm

if printf "%s\n" "${COMPREPLY[@]}" | grep -q "myproj.lib.archive"; then
    echo -e "  ${GREEN}✓${NC} Completion works for library targets"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Completion failed for library targets"
    echo "  Got: ${COMPREPLY[*]}"
    : $((TESTS_FAILED += 1))
fi

# Test completing package targets
export COMP_WORDS=(mm myproj.pkg.)
export COMP_CWORD=1
export COMP_LINE="mm myproj.pkg."
export COMP_POINT=14
COMPREPLY=()
_comp_cmd_mm

if printf "%s\n" "${COMPREPLY[@]}" | grep -q "myproj.pkg.pyc"; then
    echo -e "  ${GREEN}✓${NC} Completion works for package targets"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} Completion failed for package targets"
    echo "  Got: ${COMPREPLY[*]}"
    : $((TESTS_FAILED += 1))
fi

# =============================================================================
# Test 10: Docker-image, webpack, vite, verbatim asset parsing
# =============================================================================
echo -e "\n${BLUE}Testing docker/webpack/vite/verbatim asset parsing:${NC}"

# Create a config with all asset types
cat > "$TEMP_DIR/.mm/fullproj.mm" << 'EOF'
fullproj.docker-images := fullproj.img
fullproj.webpack := fullproj.wp
fullproj.vite := fullproj.vt
fullproj.verbatim := fullproj.verb
EOF

ASSETS=$(_comp_cmd_mm__parse_assets "$TEMP_DIR")

check_asset_type() {
    local expected=$1
    if echo "$ASSETS" | grep -q "^$expected$"; then
        echo -e "  ${GREEN}✓${NC} Found asset: $expected"
        : $((TESTS_PASSED += 1))
    else
        echo -e "  ${RED}✗${NC} Missing asset: $expected"
        echo "  All assets: $ASSETS"
        : $((TESTS_FAILED += 1))
    fi
}

check_asset_type "docker|fullproj.img"
check_asset_type "webpack|fullproj.wp"
check_asset_type "vite|fullproj.vt"
check_asset_type "verbatim|fullproj.verb"

# Verify suffixed targets are generated
ALL_TARGETS=$(_comp_cmd_mm__get_all_targets)

check_target "fullproj.img"
check_target "fullproj.img.build"
check_target "fullproj.img.run"
check_target "fullproj.img.launch"
check_target "fullproj.img.info"
check_target "fullproj.img.help"

check_target "fullproj.wp"
check_target "fullproj.wp.clean"
check_target "fullproj.wp.generated"
check_target "fullproj.wp.chunks"
check_target "fullproj.wp.npm_modules"
check_target "fullproj.wp.info"
check_target "fullproj.wp.help"

check_target "fullproj.vt"
check_target "fullproj.vt.config"
check_target "fullproj.vt.stage.files"
check_target "fullproj.vt.stage.modules"
check_target "fullproj.vt.info"
check_target "fullproj.vt.help"

check_target "fullproj.verb"
check_target "fullproj.verb.clean"
check_target "fullproj.verb.info"
check_target "fullproj.verb.info.files"
check_target "fullproj.verb.info.staged.files"
check_target "fullproj.verb.help"

# =============================================================================
# Test 11: mm-target-help command
# =============================================================================
echo -e "\n${BLUE}Testing mm-target-help command:${NC}"

OUTPUT=$(mm-target-help help)
if [[ "$OUTPUT" == *"usage"* ]]; then
    echo -e "  ${GREEN}✓${NC} mm-target-help returns description for 'help'"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} mm-target-help failed for 'help'"
    echo "  Got: $OUTPUT"
    : $((TESTS_FAILED += 1))
fi

OUTPUT=$(mm-target-help nonexistent-target-xyz)
if [[ "$OUTPUT" == *"No description"* ]]; then
    echo -e "  ${GREEN}✓${NC} mm-target-help handles unknown targets"
    : $((TESTS_PASSED += 1))
else
    echo -e "  ${RED}✗${NC} mm-target-help didn't handle unknown target"
    echo "  Got: $OUTPUT"
    : $((TESTS_FAILED += 1))
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${BLUE}========================================${NC}"
TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo -e "  Results: ${GREEN}${TESTS_PASSED}${NC} passed, ${RED}${TESTS_FAILED}${NC} failed (${TOTAL} total)"
echo -e "${BLUE}========================================${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
fi
