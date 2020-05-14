#!/bin/sh -x

MACHINE_NAME=`uname -m`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/aarch64-linux-gnu/jni
export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
export ANT_HOME=/usr/bin/ant

echo "Building for OpenCV $OPENCV_VERSION-$OPENCV_OPNP_REV on: \n `uname -a` \n"

# Apply JNI Debian hacks, avoids OpenCV's cmake going:
# "Could NOT find JNI (missing: JAVA_AWT_LIBRARY JAVA_JVM_LIBRARY JAVA_INCLUDE_PATH ...)"
ln -sf /usr/lib/$MACHINE_NAME-linux-gnu/jni/libjnidispatch.system.so /usr/lib/$MACHINE_NAME-linux-gnu/jni/ libjnidispatch.so

# Get and install a proper JVM
wget https://corretto.aws/downloads/latest/amazon-corretto-11-$MACHINE_NAME-linux-jdk.deb && dpkg -i *.deb && rm *.deb

cd opencv/opencv-$OPENCV_VERSION/target/linux/ARMv8
cmake -D BUILD_SHARED_LIBS=OFF -D WITH_EIGEN=OFF -D WITH_FFMPEG=OFF -D WITH_JAVA=ON ../../..
make -j8
cd ../../.. && ./copy-resources.sh $OPENCV_VERSION
mvn clean test
