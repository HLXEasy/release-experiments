#!/bin/bash
# ----------------------------------------------------------------------------
#  Copyright (c) 2018 The Spectrecoin developers
#
#  @author   HLXEasy <helix@spectreproject.io>
# ----------------------------------------------------------------------------

_init() {
#    if [[ -n "${TERM}" && "${TERM}" != "dumb" ]]; then
        GREEN='\e[0;32m' RED='\e[0;31m' BLUE='\e[0;34m' NORMAL='\e[0m'
#    else
#        GREEN="" RED="" BLUE="" NORMAL=""
#    fi
}

die() {
    error=${1:-1}
    shift
    error "$*" >&2
    exit ${error}
}

info() {
    printf "${GREEN}%-7s: %s${NORMAL}\n" "Info" "$*"
}

error() {
    printf "${RED}%-7s: %s${NORMAL}\n" "Error" "$*"
}

warning() {
    printf "${BLUE}%-7s: %s${NORMAL}\n" "Warning" "$*"
}

# ---------------------------------------------------------------------------
# Execute the given command and return the given error value
# in case of an error
# $1 .. Cmd to execute
# $2 .. Return value in case the given cmd did not finish successful. If a
#       negative value is given, a warning is written to the log but the
#       function returns instead of performing 'die ...'.
executeCommand() {
    local _command="$1"
    local _returnCodeForError="$2"
    echo "Executing '${_command}'"
    eval "${_command}"
    rtc=$?
    evaluateRtc ${rtc} ${_returnCodeForError}
    return ${rtc}
}

evaluateRtc(){
    local _givenRtc=$1
    local _returnCodeForError=$2
    if [[ ${_givenRtc} -ne 0 ]] ; then
        if [[ -z "$_returnCodeForError" ]] ; then
            die 80 "Error during build steps"
        elif [[ ${_returnCodeForError} -lt 0 ]] ; then
            warning "Last command finished with non-zero return code but ignoring this for now"
        else
            die ${_returnCodeForError} "Error during build steps! (${_returnCodeForError})"
        fi
    fi
}
