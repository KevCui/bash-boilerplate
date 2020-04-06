#!/usr/bin/env bats
#
# How to run:
#   ~$ bats test/test.bats

BATS_TEST_SKIPPED=

setup() {
    _SCRIPT="./boilerplate.sh"
    _PARAM_A="test a"

    source $_SCRIPT
}

teardown() {
    echo "cleanup"
}

@test "CHECK: command_not_found()" {
    run command_not_found "bats"
    [ "$status" -eq 1 ]
    [ "$output" = "[31mbats[0m command not found!" ]
}

@test "CHECK: command_not_found(): show where-to-install" {
    run command_not_found "bats" "batsland"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "[31mbats[0m command not found!" ]
    [ "${lines[1]}" = "Install from [31mbatsland[0m" ]
}

@test "CHECK: check_var(): all mandatory variables are set" {
    run check_var
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "CHECK: check_var(): no \$_PARAM_A" {
    unset _PARAM_A
    run check_var
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "-a <parama> is missing!" ]
}

@test "CHECK: print_result(): \$_PARAM_A" {
    _ECHO="$(command -v echo)"
    run print_result
    [ "$status" -eq 0 ]
    [ "$output" = "$_PARAM_A" ]
}

@test "CHECK: print_result(): \$_PARAM_A and \$_PARAM_C" {
    _ECHO="$(command -v echo)"
    _PARAM_C="test c"
    run print_result
    [ "$status" -eq 0 ]
    [ "$output" = "$_PARAM_A $_PARAM_C" ]
}

@test "CHECK: print_result(): \$_PARAM_A and \$_TRIGGER_B" {
    _ECHO="$(command -v echo)"
    _TRIGGER_B=true
    _TEXT_B="test b"
    run print_result
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$_PARAM_A" ]
    [ "${lines[1]}" = "$_TEXT_B" ]
}

@test "CHECK: print_result(): \$_PARAM_A \$_PARAM_C and \$_TRIGGER_B" {
    _ECHO="$(command -v echo)"
    _TRIGGER_B=true
    _TEXT_B="test b"
    _PARAM_C="test c"
    run print_result
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$_PARAM_A $_PARAM_C" ]
    [ "${lines[1]}" = "$_TEXT_B" ]
}
