#!/bin/sh -x

echo "Building for OpenCV $OPENCV_VERSION-$OPENCV_OPNP_REV on: \n `uname -a` \n"

cd opencv/opencv-$OPENCV_VERSION/target/linux/ARMv8
cmake -D BUILD_SHARED_LIBS=OFF \
#            -D WITH_EIGEN=OFF \
#            -D WITH_FFMPEG=OFF \
            -D WITH_JAVA=ON
make -j8
cd ../../.. && ./copy-resources $OPENCV_VERSION-$OPENCV_OPNP_REV
mvn clean test
