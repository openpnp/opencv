#!/bin/sh -x

echo "Building for OpenCV $OPENCV_VERSION-$OPENCV_OPNP_REV on: \n `uname -a` \n"

pushd opencv/opencv-$OPENCV_VERSION/target/linux/ARMv8
cmake -D BUILD_SHARED_LIBS=OFF -D WITH_EIGEN=OFF -D WITH_FFMPEG=OFF -D WITH_JAVA=ON ../../..
make -j8
popd && ./copy-resources $OPENCV_VERSION
mvn clean test
