#!/bin/bash
# ----------------------------------------------------------------------------
#  Copyright (c) 2018 The Spectrecoin developers
#
#  @author   HLXEasy <helix@spectreproject.io>
# ----------------------------------------------------------------------------

# Store path from where script was called, determine own location
# and source helper content from there
callDir=$(pwd)
ownLocation="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${ownLocation}
. ./include/helpers_console.sh

##############################################################################
# Show some help to the user
helpMe() {
    echo "
    Usage : ${0##*/} [options]

    Options:
    -h  Show this help
    "
}

getReleaseInfo() {
    docker run \
        --rm \
        -e GITHUB_TOKEN=${GITHUB_TOKEN} \
        spectreproject/github-uploader:latest \
        github-release info \
            --user ${GITHUB_USER} \
            --repo ${GITHUB_REPOSITORY} | sed -e "1,/releases:/d" | grep -- '- .*, name:' | grep "${GITHUB_TAG}"
}

######### HANDLE OPTIONS, CALL MAIN #########
_init
GITHUB_DESCRIPTION=''
GITHUB_NAME=''
GITHUB_PRERELEASE=false
GITHUB_REPOSITORY=''
GITHUB_TAG=''
GITHUB_USER=''
OPERATION_TO_DO='info'

rtc=0
while getopts d:n:pr:t:u:h? option; do
    case ${option} in
        d) GITHUB_DESCRIPTION="${OPTARG}";;
        n) GITHUB_NAME="${OPTARG}";;
        o) OPERATION_TO_DO="${OPTARG}";;
        p) GITHUB_PRERELEASE=true;;
        r) GITHUB_REPOSITORY="${OPTARG}";;
        t) GITHUB_TAG="${OPTARG}";;
        u) GITHUB_USER="${OPTARG}";;
        h|?) helpMe && exit 0;;
        *) die 90 "invalid option \"${OPTARG}\"";;
    esac
done
if [[ $# -eq 0 ]] ; then helpMe && exit 0 ; fi
if [[ -z ${GITHUB_TOKEN} ]] ; then die 100 "GITHUB_TOKEN not set on environment!" ; fi

case ${OPERATION_TO_DO} in
    delete)
        info "Not yet implemented";;
    download)
        info "Not yet implemented";;
    edit)
        info "Not yet implemented";;
    info)
        getReleaseInfo;;
    release)
        info "Not yet implemented";;
    upload)
        info "Not yet implemented";;
    *)
        die 110 "Unknown github-release option '${OPERATION_TO_DO}'"
esac
