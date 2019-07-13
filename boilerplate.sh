#!/usr/bin/env bash
#
# (A short description about this script)
#
#/ Usage:
#/   ./boilerplate.sh -a <parama> [-b|-c <paramc>]
#/
#/ Options:
#/   -a               Required, param a
#/   -b               Optional, trigger b
#/   -c               Optional, param c
#/   -h | --help      Display this help message
#/
#/ Examples:
#/   \e[32m- This is an exmaple:\e[0m
#/     ~$ ./boilerplate.sh \e[33m-a 'hello'\e[0m

set -e
set -u

usage() {
    # Display usage message
    printf "\n%b\n" "$(grep '^#/' "$0" | cut -c4-)" && exit 0
}

set_var() {
    # Declare variables
    _TEXT_B="B triggered!"
}

set_command() {
    # Declare commands
    _ECHO="$(command -v echo)" || command_not_found "echo"
}

set_args() {
    # Declare arguments
    expr "$*" : ".*--help" > /dev/null && usage
    while getopts ":hba:c:" opt; do
        case $opt in
            a)
                _PARAM_A="$OPTARG"
                ;;
            b)
                _TRIGGER_B=true
                ;;
            c)
                _PARAM_C="$OPTARG"
                ;;
            h)
                usage
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                usage
                ;;
        esac
    done
}

command_not_found() {
    # Show command not found message
    # $1: command name
    printf "%b\n" '\033[31m'"$1"'\033[0m command not found!' && exit 1
}

check_var() {
    # Check variables if exist
    if [[ -z "${_PARAM_A:-}" ]]; then
        echo '-a <parama> is missing!' && usage
    fi
}

print_result() {
    local output
    if [[ ${_PARAM_C:-} ]]; then
        output="$_PARAM_A $_PARAM_C"
    else
        output="$_PARAM_A"
    fi

    if [[ ${_TRIGGER_B:-} ]]; then
        output="$output\n$_TEXT_B"
    fi
    $_ECHO -e "$output" >&2
}

main() {
    set_args "$@"
    set_command
    set_var
    check_var
    print_result
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
