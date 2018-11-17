#!/bin/bash
# ----------------------------------------------------------------------------
#  Copyright (c) 2018 The Spectrecoin developers
#
#  @author   HLXEasy <helix@spectreproject.io>
# ----------------------------------------------------------------------------
 set -x
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
    # See https://stackoverflow.com/questions/7103531/how-to-get-the-part-of-file-after-the-line-that-matches-grep-expression-first
    # - sed statement to get all content below 'releases:'
    # - grep to filter first line of each release. They look i. e. like this: "- 2.1.0, name: 'Spectrecoin v2.1.0'..."
    #   Must be done this way as the whole release notes will be shown here
    docker run \
        --rm \
        -t \
        -e GITHUB_TOKEN=${GITHUB_TOKEN} \
        spectreproject/github-uploader:latest \
        github-release info \
            --user ${GITHUB_USER} \
            --repo ${GITHUB_REPOSITORY} | sed -e "1,/releases:/d" | grep -- "- ${GITHUB_TAG}, name: "
}

removeRelease() {
    docker run \
        --rm \
        -t \
        -e GITHUB_TOKEN=${GITHUB_TOKEN} \
        spectreproject/github-uploader:latest \
        github-release delete \
            --user ${GITHUB_USER} \
            --repo ${GITHUB_REPOSITORY} \
            --tag ${GITHUB_TAG}
}

createRelease() {
    if ${GITHUB_PRERELEASE} ; then
        preReleaseOption='--pre-release'
    else
        preReleaseOption=''
    fi
    docker run \
        --rm \
        -t \
        -e GITHUB_TOKEN=${GITHUB_TOKEN} \
        spectreproject/github-uploader:latest \
        github-release release \
            --user ${GITHUB_USER} \
            --repo ${GITHUB_REPOSITORY} \
            --tag ${GITHUB_TAG} \
            --name "${GITHUB_NAME}" \
            --description "${GITHUB_DESCRIPTION}" \
            ${preReleaseOption}
}

uploadArtifactToRelease() {
    docker run \
        --rm \
        -t \
        -e GITHUB_TOKEN=${GITHUB_TOKEN} \
        -v ${WORKSPACE}:/filesToUpload \
        spectreproject/github-uploader:latest \
        github-release upload \
            --user ${GITHUB_USER} \
            --repo ${GITHUB_REPOSITORY} \
            --tag ${GITHUB_TAG} \
            --name "${GITHUB_FINAL_NAME}" \
            --file /filesToUpload/${ARTIFACT_TO_UPLOAD} \
            --replace
}

######### HANDLE OPTIONS, CALL MAIN #########
_init
ARTIFACT_TO_UPLOAD=''
GITHUB_DESCRIPTION=''
GITHUB_FINAL_NAME=''
GITHUB_NAME=''
GITHUB_PRERELEASE=false
GITHUB_REPOSITORY=''
GITHUB_TAG=''
GITHUB_USER=''
OPERATION_TO_DO='info'
WORKSPACE=.

rtc=0
while getopts a:d:f:n:o:pr:t:u:w:h? option; do
    case ${option} in
        a) ARTIFACT_TO_UPLOAD="${OPTARG}";;
        d) GITHUB_DESCRIPTION="${OPTARG}";;
        f) GITHUB_FINAL_NAME="${OPTARG}";;
        n) GITHUB_NAME="${OPTARG}";;
        o) OPERATION_TO_DO="${OPTARG}";;
        p) GITHUB_PRERELEASE=true;;
        r) GITHUB_REPOSITORY="${OPTARG}";;
        t) GITHUB_TAG="${OPTARG}";;
        u) GITHUB_USER="${OPTARG}";;
        w) WORKSPACE="${OPTARG}";;
        h|?) helpMe && exit 0;;
        *) die 90 "invalid option \"${OPTARG}\"";;
    esac
done
if [[ $# -eq 0 ]] ; then helpMe && exit 0 ; fi
if [[ -z ${GITHUB_TOKEN} ]] ; then die 100 "GITHUB_TOKEN not set on environment!" ; fi

case ${OPERATION_TO_DO} in
    delete)
        removeRelease;;
    download)
        info "Not yet implemented";;
    edit)
        info "Not yet implemented";;
    info)
        getReleaseInfo;;
    release)
        createRelease;;
    upload)
        uploadArtifactToRelease;;
    *)
        die 110 "Unknown github-release option '${OPERATION_TO_DO}'"
esac
