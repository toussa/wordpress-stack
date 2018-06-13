#!/bin/bash

# Use this script to generate files from specific template.
# It replaces shell variables from template with environment variables,
# but ONLY if it's set ( means that $UnknownEnv won't be replaced with an empty value)

cmdname=$(basename $0)

echoerr() { if [[ $QUIET -ne 1 ]]; then echo "$@" 1>&2; fi }

usage()
{
    cat << USAGE >&2
Usage:
    $cmdname template:output [-q] [-- command [args...]]
    template        Template file to use
    output          Output file that will be generated
    -q | --quiet    Don't output any status messages
    -- COMMAND ARGS    Execute command with args after the detemplatization
USAGE
    exit 1
}


# process arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        *:* )
        files=(${1//:/ })
        TEMPLATE=${files[0]}
        OUTPUT=${files[1]}
        shift 1
        ;;
        -h | --help)
	usage
	;;
        -q | --quiet)
        QUIET=1
	shift 1
        ;;
	--)
        shift
        CLI="$@"
        break
        ;;
        *)
        echoerr "Unknown argument: $1"
        usage
        ;;
    esac
done

if [[ "$TEMPLATE" == "" || "$OUTPUT" == "" ]]; then
    echoerr "Error: you need to provide a template file and an output file to generate."
    usage
fi

QUIET=${QUIET:-0}

envsubst "`compgen -e | sed s/^/$/ `" < $TEMPLATE > $OUTPUT

if [[ $CLI != "" ]]; then
	exec $CLI
fi

