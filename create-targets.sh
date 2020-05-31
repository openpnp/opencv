#!/bin/bash -x

VERSION=$1
SHORT_VERSION=`echo $VERSION | tr -d .`
BASE_DIR=opencv-$VERSION

echo "Version: $VERSION"
echo "Short Version: $SHORT_VERSION"
echo "Base Dir: $BASE_DIR"

mkdir -p $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
