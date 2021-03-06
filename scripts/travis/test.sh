#!/usr/bin/env bash

set -e
set -x

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OS=$("${SCRIPTPATH}/../ostype.sh")
ARCH=$("${SCRIPTPATH}/../archtype.sh")

# Use go version specified by get_golang_version.sh
if ! GOLANG_VERSION=$("${SCRIPTPATH}/../get_golang_version.sh")
then
    echo "${GOLANG_VERSION}"
    exit 1
fi

curl -sL -o ~/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/gimme
eval $(~/gimme "${GOLANG_VERSION}")

if [ "${OS}-${ARCH}" = "linux-arm" ] || [ "${OS}-${ARCH}" = "windows-amd64" ]; then
     # for arm, no tests need to be invoked.
     # for now, disable tests on windows.
     exit 0
 fi

GOPATHBIN=$(go env GOPATH)/bin
export PATH=$PATH:$GOPATHBIN

make fixcheck
scripts/travis/run_tests.sh;
scripts/travis/after_build.sh;
