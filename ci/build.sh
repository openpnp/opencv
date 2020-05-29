#!/bin/sh -x

MACHINE_NAME=`uname -m`
# https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html
JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-$MACHINE_NAME-$TRAVIS_OS_NAME-jdk.deb"
export LD_LIBRARY_PATH=/usr/lib/$MACHINE_NAME-linux-gnu/jni
export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
export ANT_HOME=/usr/bin/ant

echo "Building for OpenCV $OPENCV_VERSION-$OPENCV_OPNP_REV on: \n `uname -a` \n"

# Apply JNI Debian hacks, avoids OpenCV's cmake going:
# "Could NOT find JNI (missing: JAVA_AWT_LIBRARY JAVA_JVM_LIBRARY JAVA_INCLUDE_PATH ...)"
ls -alh /usr/lib/*-gnu/jni/*
sudo ln -sf /usr/lib/$MACHINE_NAME-linux-gnu/jni/libjnidispatch.system.so \
            /usr/lib/$MACHINE_NAME-linux-gnu/jni/libjnidispatch.so

# Get and install a proper JVM
# Tweak for the inconsistent naming conventions between uname, AWS and TravisCI
if [ $MACHINE_NAME == "x86_64" ]
	case "$TRAVIS_OS_NAME" in
		osx) JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-x64-macos-jdk.deb";;
		windows) JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-x64-$TRAVIS_OS_NAME-jdk.deb";;
		linux) JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-x64-$TRAVIS_OS_NAME-jdk.deb"
	esac
fi

# Download and install Corretto JDK
wget JVM_URL \ 
     && sudo dpkg -i *.deb \
     && rm *.deb

# Prepare by creating target dirs
echo "Create target dirs for $MACHINE_NAME"
./create-targets.sh $1 && pwd

# XXX: ARMv8 for conditional folder detection
cd opencv-$OPENCV_VERSION/target/linux/ARMv8
cmake -D BUILD_SHARED_LIBS=OFF \
      -D BUILD_TESTING_SHARED=OFF \
      -D BUILD_TESTING_STATIC=OFF \
      -D BUILD_TESTING=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D WITH_EIGEN=OFF \
      -D WITH_FFMPEG=OFF \
      -D WITH_JAVA=ON ../../..
make -j8

# Find resulting opencv430.jar and libopencv_java430.so, should be under "upstream" folder
echo "Looking up for JNA-JNI related objects"
find $HOME -iname "opencv-*.jar"
find $HOME -iname "libopencv_java*.*"

echo "Copy OpenCV resources\n"
cd $TRAVIS_BUILD_DIR && ./copy-resources.sh $OPENCV_VERSION

# XXX: This is not needed at all if we already have the bins, right?
#mvn clean test
