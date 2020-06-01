#!/bin/bash -x

VERSION=$1
BASE_DIR=opencv-$VERSION
SHORT_VERSION=`echo $VERSION | tr -d .`
DEPLOY=$TRAVIS_BUILD_DIR/deploy
TARGET_PREFIX=opencv/opencv-$VERSION/target

mkdir -p $DEPLOY

if [ $TRAVIS_OS_NAME = osx ]
then
	cp $TRAVIS_BUILD_DIR/$TARGET_PREFIX/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java430.dylib $DEPLOY
fi

if [ $TRAVIS_OS_NAME = linux ]
then
	case "$TRAVIS_CPU_ARCH" in
		arm64)
			cp $TRAVIS_BUILD_DIR/$TARGET_PREFIX/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java430.so $DEPLOY
		;;
		amd64)
			cp $TRAVIS_BUILD_DIR/$TARGET_PREFIX/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java430.so $DEPLOY
		;;
	esac
fi

if [ $TRAVIS_OS_NAME = windows ]
then
	case "$TRAVIS_CPU_ARCH" in		
		amd64)
			cp $TRAVIS_BUILD_DIR/$TARGET_PREFIX/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java430.dll $DEPLOY
		;;
#		x86_32)
#			cp $TRAVIS_BUILD_DIR/$TARGET_PREFIX/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java430.so $DEPLOY
#		;;
	esac
fi
