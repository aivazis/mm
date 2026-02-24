#!/usr/bin/env zsh
#
# Test script for mm zsh completion
# This script tests the completion helper functions and target generation
# Run with: zsh test-completion.zsh

setopt NO_ERR_EXIT NO_ERR_RETURN
setopt EXTENDED_GLOB

# Colors for output
GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0

# Source the completion script
SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/_mm"

echo "${BLUE}Testing mm zsh completion...${NC}\n"

# =============================================================================
# Test helper functions
# =============================================================================

pass() {
    local msg=$1
    echo "  ${GREEN}✓${NC} $msg"
    : $((TESTS_PASSED += 1))
}

fail() {
    local msg=$1
    shift
    echo "  ${RED}✗${NC} $msg"
    for line in "$@"; do
        echo "    $line"
    done
    : $((TESTS_FAILED += 1))
}

# Check that a string is found in output
assert_contains() {
    local label=$1
    local haystack=$2
    local needle=$3

    if [[ "$haystack" == *"$needle"* ]]; then
        pass "$label"
    else
        fail "$label" "Expected to contain: $needle" "Got: ${haystack:0:200}"
    fi
}

# Check that a string is NOT found in output
assert_not_contains() {
    local label=$1
    local haystack=$2
    local needle=$3

    if [[ "$haystack" != *"$needle"* ]]; then
        pass "$label"
    else
        fail "$label" "Should NOT contain: $needle"
    fi
}

# Check that a value appears as a complete line in output
assert_line() {
    local label=$1
    local output=$2
    local expected=$3

    if echo "$output" | grep -qx "$expected" 2>/dev/null; then
        pass "$label"
    else
        fail "$label" "Expected line: $expected" "Output: ${output:0:200}"
    fi
}

# Check that a value does NOT appear as a complete line
assert_no_line() {
    local label=$1
    local output=$2
    local excluded=$3

    if ! echo "$output" | grep -qx "$excluded" 2>/dev/null; then
        pass "$label"
    else
        fail "$label" "Should NOT have line: $excluded"
    fi
}

# =============================================================================
# Test 1: Global target spec data
# =============================================================================
echo "\n${BLUE}Test 1: Global target specs${NC}"

# Verify the global target spec array is populated
if (( ${#_mm_global_target_specs} > 0 )); then
    pass "Global target specs array is populated (${#_mm_global_target_specs} entries)"
else
    fail "Global target specs array is empty"
fi

# Check specific entries exist
assert_contains "Has 'help' target" "${_mm_global_target_specs[*]}" "help:Show usage"
assert_contains "Has 'clean' target" "${_mm_global_target_specs[*]}" "clean:Clean all"
assert_contains "Has 'tidy' target" "${_mm_global_target_specs[*]}" "tidy:Delete backup"
assert_contains "Has 'tests' target" "${_mm_global_target_specs[*]}" "tests:Run all"
assert_contains "Has 'projects' target" "${_mm_global_target_specs[*]}" "projects:Build all"
assert_contains "Has 'mm.info' target" "${_mm_global_target_specs[*]}" "mm.info:Show important"
assert_contains "Has 'builder.info' target" "${_mm_global_target_specs[*]}" "builder.info:Show builder"
assert_contains "Has 'platform.info' target" "${_mm_global_target_specs[*]}" "platform.info:Show platform"
assert_contains "Has 'host.info' target" "${_mm_global_target_specs[*]}" "host.info:Show host"
assert_contains "Has 'extern.info' target" "${_mm_global_target_specs[*]}" "extern.info:Show external"
assert_contains "Has 'extern.db.clean' target" "${_mm_global_target_specs[*]}" "extern.db.clean:Remove package"
assert_contains "Has 'libraries.info' target" "${_mm_global_target_specs[*]}" "libraries.info:List known"
assert_contains "Has 'packages.info' target" "${_mm_global_target_specs[*]}" "packages.info:List known"
assert_contains "Has 'extensions.info' target" "${_mm_global_target_specs[*]}" "extensions.info:List known"

# =============================================================================
# Test 2: Suffix spec tables
# =============================================================================
echo "\n${BLUE}Test 2: Suffix spec tables${NC}"

if (( ${#_mm_library_suffix_specs} == 21 )); then
    pass "Library suffix specs: ${#_mm_library_suffix_specs} entries"
else
    fail "Library suffix specs: expected 21, got ${#_mm_library_suffix_specs}"
fi

if (( ${#_mm_package_suffix_specs} == 18 )); then
    pass "Package suffix specs: ${#_mm_package_suffix_specs} entries"
else
    fail "Package suffix specs: expected 18, got ${#_mm_package_suffix_specs}"
fi

if (( ${#_mm_extension_suffix_specs} == 11 )); then
    pass "Extension suffix specs: ${#_mm_extension_suffix_specs} entries"
else
    fail "Extension suffix specs: expected 11, got ${#_mm_extension_suffix_specs}"
fi

if (( ${#_mm_testsuite_suffix_specs} == 8 )); then
    pass "Test suite suffix specs: ${#_mm_testsuite_suffix_specs} entries"
else
    fail "Test suite suffix specs: expected 8, got ${#_mm_testsuite_suffix_specs}"
fi

if (( ${#_mm_docker_suffix_specs} == 6 )); then
    pass "Docker suffix specs: ${#_mm_docker_suffix_specs} entries"
else
    fail "Docker suffix specs: expected 6, got ${#_mm_docker_suffix_specs}"
fi

if (( ${#_mm_webpack_suffix_specs} == 20 )); then
    pass "Webpack suffix specs: ${#_mm_webpack_suffix_specs} entries"
else
    fail "Webpack suffix specs: expected 20, got ${#_mm_webpack_suffix_specs}"
fi

if (( ${#_mm_vite_suffix_specs} == 10 )); then
    pass "Vite suffix specs: ${#_mm_vite_suffix_specs} entries"
else
    fail "Vite suffix specs: expected 10, got ${#_mm_vite_suffix_specs}"
fi

if (( ${#_mm_verbatim_suffix_specs} == 7 )); then
    pass "Verbatim suffix specs: ${#_mm_verbatim_suffix_specs} entries"
else
    fail "Verbatim suffix specs: expected 7, got ${#_mm_verbatim_suffix_specs}"
fi

# Verify specific suffixes
assert_contains "Library has .archive" "${_mm_library_suffix_specs[*]}" ".archive:Build static archive"
assert_contains "Library has .dll" "${_mm_library_suffix_specs[*]}" ".dll:Build shared library"
assert_contains "Package has .pyc" "${_mm_package_suffix_specs[*]}" ".pyc:Byte-compile"
assert_contains "Package has .drivers" "${_mm_package_suffix_specs[*]}" ".drivers:Export driver"
assert_contains "Extension has .extension" "${_mm_extension_suffix_specs[*]}" ".extension:Build the .so"
assert_contains "Extension has .capsule" "${_mm_extension_suffix_specs[*]}" ".capsule:Publish capsule"
assert_contains "Test has .testcases" "${_mm_testsuite_suffix_specs[*]}" ".testcases:Build all test"
assert_contains "Docker has .build" "${_mm_docker_suffix_specs[*]}" ".build:Run docker build"
assert_contains "Docker has .launch" "${_mm_docker_suffix_specs[*]}" ".launch:Run docker interactively"

# =============================================================================
# Test 3: Project root finder
# =============================================================================
echo "\n${BLUE}Test 3: Project root finder${NC}"

# Create a temp project structure
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

mkdir -p "$TEMP_DIR/.mm"
mkdir -p "$TEMP_DIR/sub/dir"

# Test from project root
(
    cd "$TEMP_DIR"
    local result=$(_mm_find_project_root)
    if [[ "$result" == "$TEMP_DIR" ]]; then
        pass "Finds project root from root dir"
    else
        fail "Project root from root dir" "Expected: $TEMP_DIR" "Got: $result"
    fi
)

# Test from subdirectory
(
    cd "$TEMP_DIR/sub/dir"
    local result=$(_mm_find_project_root)
    if [[ "$result" == "$TEMP_DIR" ]]; then
        pass "Finds project root from subdirectory"
    else
        fail "Project root from subdirectory" "Expected: $TEMP_DIR" "Got: $result"
    fi
)

# Test from directory without .mm/
(
    cd /tmp
    local result=$(_mm_find_project_root)
    if [[ -z "$result" ]]; then
        pass "Returns empty when no .mm/ found"
    else
        fail "No .mm/ found" "Expected empty, got: $result"
    fi
)

# =============================================================================
# Test 4: Project configuration parsing
# =============================================================================
echo "\n${BLUE}Test 4: Config parsing (_mm_parse_assets)${NC}"

# Create project configuration with all asset types
cat > "$TEMP_DIR/.mm/myproj.mm" << 'MMEOF'
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
MMEOF

ASSETS=$(_mm_parse_assets "$TEMP_DIR")

assert_line "Found library asset" "$ASSETS" "library|myproj.lib"
assert_line "Found package asset" "$ASSETS" "package|myproj.pkg"
assert_line "Found extension asset" "$ASSETS" "extension|myproj.ext"
assert_line "Found test suite serial" "$ASSETS" "testsuite|myproj.tests.serial"
assert_line "Found test suite unit" "$ASSETS" "testsuite|myproj.tests.unit"

# =============================================================================
# Test 5: Docker, webpack, vite, verbatim asset parsing
# =============================================================================
echo "\n${BLUE}Test 5: Docker/webpack/vite/verbatim parsing${NC}"

cat > "$TEMP_DIR/.mm/fullproj.mm" << 'MMEOF'
fullproj.docker-images := fullproj.img
fullproj.webpack := fullproj.wp
fullproj.vite := fullproj.vt
fullproj.verbatim := fullproj.verb
MMEOF

ASSETS=$(_mm_parse_assets "$TEMP_DIR")

assert_line "Found docker asset" "$ASSETS" "docker|fullproj.img"
assert_line "Found webpack asset" "$ASSETS" "webpack|fullproj.wp"
assert_line "Found vite asset" "$ASSETS" "vite|fullproj.vt"
assert_line "Found verbatim asset" "$ASSETS" "verbatim|fullproj.verb"

# =============================================================================
# Test 6: Multi-line asset declarations (backslash continuation)
# =============================================================================
echo "\n${BLUE}Test 6: Multi-line asset declarations${NC}"

cat > "$TEMP_DIR/.mm/multiline.mm" << 'MMEOF'
multiline.libraries := \
    multi.lib1 \
    multi.lib2

multiline.packages := multi.pkg1 multi.pkg2
MMEOF

ASSETS=$(_mm_parse_assets "$TEMP_DIR")

assert_line "Multi-line library 1" "$ASSETS" "library|multi.lib1"
assert_line "Multi-line library 2" "$ASSETS" "library|multi.lib2"
assert_line "Same-line package 1" "$ASSETS" "package|multi.pkg1"
assert_line "Same-line package 2" "$ASSETS" "package|multi.pkg2"

# =============================================================================
# Test 7: Project names
# =============================================================================
echo "\n${BLUE}Test 7: Project names${NC}"

PROJ_NAMES=$(_mm_get_project_names "$TEMP_DIR")

assert_line "Found project: myproj" "$PROJ_NAMES" "myproj"
assert_line "Found project: fullproj" "$PROJ_NAMES" "fullproj"
assert_line "Found project: multiline" "$PROJ_NAMES" "multiline"

# =============================================================================
# Test 8: Test suite parsing
# =============================================================================
echo "\n${BLUE}Test 8: Test suite parsing${NC}"

# Create test directories and files
mkdir -p "$TEMP_DIR/TEST/serial"
mkdir -p "$TEMP_DIR/TEST/unit/math"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/hello.cc"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/world.cc"
echo "int main() {}" > "$TEMP_DIR/TEST/serial/excluded-test.cc"
echo "# test" > "$TEMP_DIR/TEST/unit/basic.py"
echo "# test" > "$TEMP_DIR/TEST/unit/deprecated.py"
echo "int main() {}" > "$TEMP_DIR/TEST/unit/math/calc.cc"

SUITES=$(_mm_parse_test_suites "$TEMP_DIR")

assert_contains "Found serial suite" "$SUITES" "serial|TEST/serial/"
assert_contains "Found unit suite" "$SUITES" "unit|TEST/unit/"

# =============================================================================
# Test 9: Test exclusion parsing
# =============================================================================
echo "\n${BLUE}Test 9: Exclusion parsing${NC}"

EXCL=$(_mm_get_exclusions "$TEMP_DIR" "serial")
assert_contains "Found serial exclusion" "$EXCL" "excluded-test.cc"

EXCL=$(_mm_get_exclusions "$TEMP_DIR" "unit")
assert_contains "Found unit exclusion" "$EXCL" "deprecated.py"

# =============================================================================
# Test 10: Exclusion matching
# =============================================================================
echo "\n${BLUE}Test 10: Exclusion matching (_mm_is_excluded)${NC}"

if _mm_is_excluded "excluded-test.cc" "excluded-test.cc"; then
    pass "Matches direct exclusion"
else
    fail "Direct exclusion match failed"
fi

if ! _mm_is_excluded "hello.cc" "excluded-test.cc"; then
    pass "Non-excluded file passes"
else
    fail "Non-excluded file was incorrectly excluded"
fi

if _mm_is_excluded "subdir/excluded-test.cc" "excluded-test.cc"; then
    pass "Matches exclusion in subdirectory"
else
    fail "Subdirectory exclusion match failed"
fi

# =============================================================================
# Test 11: Test target discovery (filesystem scan)
# =============================================================================
echo "\n${BLUE}Test 11: Test target discovery${NC}"

(
    cd "$TEMP_DIR"
    TARGETS=$(_mm_get_test_targets "$TEMP_DIR")

    assert_line "Found test target: TEST.serial.hello" "$TARGETS" "TEST.serial.hello"
    assert_line "Found test target: TEST.serial.world" "$TARGETS" "TEST.serial.world"
    assert_line "Found test target: TEST.unit.basic" "$TARGETS" "TEST.unit.basic"
    assert_line "Found test target: TEST.unit.math.calc" "$TARGETS" "TEST.unit.math.calc"
    assert_line "Found subdir target: TEST.unit.math" "$TARGETS" "TEST.unit.math"
    assert_line "Found suite root target: TEST.serial" "$TARGETS" "TEST.serial"
    assert_line "Found suite root target: TEST.unit" "$TARGETS" "TEST.unit"

    # Excluded tests should NOT appear
    assert_no_line "Excluded: TEST.serial.excluded-test" "$TARGETS" "TEST.serial.excluded-test"
    assert_no_line "Excluded: TEST.unit.deprecated" "$TARGETS" "TEST.unit.deprecated"
)

# =============================================================================
# Test 12: mm-target-help command
# =============================================================================
echo "\n${BLUE}Test 12: mm-target-help command${NC}"

OUTPUT=$(mm-target-help help)
assert_contains "mm-target-help 'help'" "$OUTPUT" "usage"

OUTPUT=$(mm-target-help clean)
assert_contains "mm-target-help 'clean'" "$OUTPUT" "Clean"

OUTPUT=$(mm-target-help mm.info)
assert_contains "mm-target-help 'mm.info'" "$OUTPUT" "mm variables"

OUTPUT=$(mm-target-help foo.dll)
assert_contains "mm-target-help 'foo.dll'" "$OUTPUT" "shared library"

OUTPUT=$(mm-target-help foo.archive)
assert_contains "mm-target-help 'foo.archive'" "$OUTPUT" "static archive"

OUTPUT=$(mm-target-help foo.pyc)
assert_contains "mm-target-help 'foo.pyc'" "$OUTPUT" "Byte-compile"

OUTPUT=$(mm-target-help foo.testcases)
assert_contains "mm-target-help 'foo.testcases'" "$OUTPUT" "test cases"

OUTPUT=$(mm-target-help foo.build)
assert_contains "mm-target-help 'foo.build'" "$OUTPUT" "docker build"

OUTPUT=$(mm-target-help foo.launch)
assert_contains "mm-target-help 'foo.launch'" "$OUTPUT" "interactively"

OUTPUT=$(mm-target-help nonexistent-target-xyz)
assert_contains "mm-target-help unknown target" "$OUTPUT" "No description"

# Test listing all targets (no argument)
OUTPUT=$(mm-target-help)
assert_contains "mm-target-help lists usage" "$OUTPUT" "Usage:"
assert_contains "mm-target-help lists globals" "$OUTPUT" "Global targets"
assert_contains "mm-target-help includes 'help'" "$OUTPUT" "help"
assert_contains "mm-target-help includes 'clean'" "$OUTPUT" "clean"

# =============================================================================
# Test 13: mm_find_mm_home with MM_HOME
# =============================================================================
echo "\n${BLUE}Test 13: mm_find_mm_home${NC}"

# Test with MM_HOME set
(
    MM_MAKE_DIR=$(mktemp -d)
    mkdir -p "$MM_MAKE_DIR/make"
    export MM_HOME="$MM_MAKE_DIR"

    local result=$(_mm_find_mm_home)
    if [[ "$result" == "$MM_MAKE_DIR" ]]; then
        pass "Finds mm home via MM_HOME"
    else
        fail "MM_HOME lookup" "Expected: $MM_MAKE_DIR" "Got: $result"
    fi

    rm -rf "$MM_MAKE_DIR"
)

# Test with DV_DIR set
(
    DV_TEMP=$(mktemp -d)
    mkdir -p "$DV_TEMP/mm/make"
    export DV_DIR="$DV_TEMP"
    unset MM_HOME

    local result=$(_mm_find_mm_home)
    if [[ "$result" == "$DV_TEMP/mm" ]]; then
        pass "Finds mm home via DV_DIR"
    else
        fail "DV_DIR lookup" "Expected: $DV_TEMP/mm" "Got: $result"
    fi

    rm -rf "$DV_TEMP"
)

# =============================================================================
# Test 14: Extern target discovery
# =============================================================================
echo "\n${BLUE}Test 14: Extern/variant/language target discovery${NC}"

(
    MM_TEMP=$(mktemp -d)
    mkdir -p "$MM_TEMP/make/extern/gsl"
    mkdir -p "$MM_TEMP/make/extern/hdf5"
    mkdir -p "$MM_TEMP/make/extern/pyre"
    mkdir -p "$MM_TEMP/make/targets"
    mkdir -p "$MM_TEMP/make/languages"
    touch "$MM_TEMP/make/targets/debug.mm"
    touch "$MM_TEMP/make/targets/opt.mm"
    touch "$MM_TEMP/make/targets/shared.mm"
    touch "$MM_TEMP/make/targets/init.mm"
    touch "$MM_TEMP/make/targets/rules.mm"
    touch "$MM_TEMP/make/languages/c++.mm"
    touch "$MM_TEMP/make/languages/python.mm"
    touch "$MM_TEMP/make/languages/init.mm"
    touch "$MM_TEMP/make/languages/rules.mm"
    export MM_HOME="$MM_TEMP"

    # Test extern targets
    EXTERN=$(_mm_complete_extern_targets 2>/dev/null)
    # _mm_complete_extern_targets uses _describe which needs completion context
    # Instead, test the underlying logic directly
    local extern_dir="$MM_TEMP/make/extern"
    local extern_specs=()
    for pkg_dir in "$extern_dir"/*(N/); do
        local pkg="${pkg_dir:t}"
        extern_specs+=("extern.${pkg}.info")
    done
    local extern_list="${extern_specs[*]}"

    assert_contains "Extern: gsl" "$extern_list" "extern.gsl.info"
    assert_contains "Extern: hdf5" "$extern_list" "extern.hdf5.info"
    assert_contains "Extern: pyre" "$extern_list" "extern.pyre.info"

    # Test variant targets
    local targets_dir="$MM_TEMP/make/targets"
    local variant_specs=()
    for vf in "$targets_dir"/*.mm(N); do
        local v="${vf:t:r}"
        case "$v" in
            init|model|rules) continue ;;
        esac
        variant_specs+=("targets.${v}.info")
    done
    local variant_list="${variant_specs[*]}"

    assert_contains "Variant: debug" "$variant_list" "targets.debug.info"
    assert_contains "Variant: opt" "$variant_list" "targets.opt.info"
    assert_contains "Variant: shared" "$variant_list" "targets.shared.info"
    assert_not_contains "Variant excludes init" "$variant_list" "targets.init.info"
    assert_not_contains "Variant excludes rules" "$variant_list" "targets.rules.info"

    # Test language targets
    local lang_dir="$MM_TEMP/make/languages"
    local lang_specs=()
    for lf in "$lang_dir"/*.mm(N); do
        local l="${lf:t:r}"
        case "$l" in
            init|model|rules) continue ;;
        esac
        lang_specs+=("languages.${l}.info")
    done
    local lang_list="${lang_specs[*]}"

    assert_contains "Language: c++" "$lang_list" "languages.c++.info"
    assert_contains "Language: python" "$lang_list" "languages.python.info"
    assert_not_contains "Language excludes init" "$lang_list" "languages.init.info"
    assert_not_contains "Language excludes rules" "$lang_list" "languages.rules.info"

    rm -rf "$MM_TEMP"
)

# =============================================================================
# Test 15: Suffix spec content verification
# =============================================================================
echo "\n${BLUE}Test 15: Suffix spec content details${NC}"

# Library suffixes
assert_contains "Library: .info.sources" "${_mm_library_suffix_specs[*]}" ".info.sources:Show source"
assert_contains "Library: .info.headers" "${_mm_library_suffix_specs[*]}" ".info.headers:Show header"
assert_contains "Library: .info.objects" "${_mm_library_suffix_specs[*]}" ".info.objects:Show object"
assert_contains "Library: .info.incdirs" "${_mm_library_suffix_specs[*]}" ".info.incdirs:Show include"
assert_contains "Library: .info.api" "${_mm_library_suffix_specs[*]}" ".info.api:Show exported"
assert_contains "Library: .headers.gateway" "${_mm_library_suffix_specs[*]}" ".headers.gateway:Publish gateway"

# Package suffixes
assert_contains "Package: .meta" "${_mm_package_suffix_specs[*]}" ".meta:Build package metadata"
assert_contains "Package: .meta.source" "${_mm_package_suffix_specs[*]}" ".meta.source:Generate metadata"
assert_contains "Package: .info.pycdirs" "${_mm_package_suffix_specs[*]}" ".info.pycdirs:Show byte-compile"
assert_contains "Package: .info.package" "${_mm_package_suffix_specs[*]}" ".info.package:Show package install"

# Extension suffixes
assert_contains "Extension: .module.init" "${_mm_extension_suffix_specs[*]}" ".module.init:Build module init"
assert_contains "Extension: .module.init.clean" "${_mm_extension_suffix_specs[*]}" ".module.init.clean:Remove generated"

# Docker suffixes
assert_contains "Docker: .run" "${_mm_docker_suffix_specs[*]}" ".run:Run docker container"

# Webpack suffixes
assert_contains "Webpack: .npm_modules" "${_mm_webpack_suffix_specs[*]}" ".npm_modules:Install npm"
assert_contains "Webpack: .chunks" "${_mm_webpack_suffix_specs[*]}" ".chunks:Build external"
assert_contains "Webpack: .generated" "${_mm_webpack_suffix_specs[*]}" ".generated:Build relay-generated"
assert_contains "Webpack: .info.schema" "${_mm_webpack_suffix_specs[*]}" ".info.schema:Show schema"

# Vite suffixes
assert_contains "Vite: .stage.modules" "${_mm_vite_suffix_specs[*]}" ".stage.modules:Install/update"
assert_contains "Vite: .staging.prefix" "${_mm_vite_suffix_specs[*]}" ".staging.prefix:Create staging"

# Verbatim suffixes
assert_contains "Verbatim: .info.files" "${_mm_verbatim_suffix_specs[*]}" ".info.files:List source"
assert_contains "Verbatim: .info.staged.files" "${_mm_verbatim_suffix_specs[*]}" ".info.staged.files:List staged"
assert_contains "Verbatim: .info.staged.directories" "${_mm_verbatim_suffix_specs[*]}" ".info.staged.directories:List staged"

# =============================================================================
# Test 16: Project suffix specs
# =============================================================================
echo "\n${BLUE}Test 16: Project suffix specs${NC}"

if (( ${#_mm_project_suffix_specs} == 6 )); then
    pass "Project suffix specs: ${#_mm_project_suffix_specs} entries"
else
    fail "Project suffix specs: expected 6, got ${#_mm_project_suffix_specs}"
fi

assert_contains "Project: .directories" "${_mm_project_suffix_specs[*]}" ".directories:Create required"
assert_contains "Project: .assets" "${_mm_project_suffix_specs[*]}" ".assets:Build all"
assert_contains "Project: .clean" "${_mm_project_suffix_specs[*]}" ".clean:Clean artifacts"
assert_contains "Project: .info" "${_mm_project_suffix_specs[*]}" ".info:Show metadata"
assert_contains "Project: .info.contents" "${_mm_project_suffix_specs[*]}" ".info.contents:Show asset"
assert_contains "Project: .help" "${_mm_project_suffix_specs[*]}" ".help:Show documentation"

# =============================================================================
# Test 17: Comments and inline values in config parsing
# =============================================================================
echo "\n${BLUE}Test 17: Config parsing edge cases${NC}"

# Clean up previous configs
rm -f "$TEMP_DIR/.mm/fullproj.mm" "$TEMP_DIR/.mm/multiline.mm"

cat > "$TEMP_DIR/.mm/edgecase.mm" << 'MMEOF'
# This is a comment about libraries
edgecase.libraries := edge.lib  # inline comment
edgecase.packages := edge.pkg1 edge.pkg2  # two packages
MMEOF

ASSETS=$(_mm_parse_assets "$TEMP_DIR")

assert_line "Handles inline comment" "$ASSETS" "library|edge.lib"
assert_no_line "No comment text in output" "$ASSETS" "library|#"
assert_line "First of two packages" "$ASSETS" "package|edge.pkg1"
assert_line "Second of two packages" "$ASSETS" "package|edge.pkg2"

# =============================================================================
# Test 18: Global target count
# =============================================================================
echo "\n${BLUE}Test 18: Global target count${NC}"

# We expect exactly 42 global targets
if (( ${#_mm_global_target_specs} == 42 )); then
    pass "Exactly 42 global targets"
else
    fail "Expected 42 global targets, got ${#_mm_global_target_specs}"
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "${BLUE}========================================${NC}"
TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo "  Results: ${GREEN}${TESTS_PASSED}${NC} passed, ${RED}${TESTS_FAILED}${NC} failed (${TOTAL} total)"
echo "${BLUE}========================================${NC}"

if (( TESTS_FAILED == 0 )); then
    echo "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo "\n${RED}Some tests failed!${NC}"
    exit 1
fi
