#!/bin/bash -x

# https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html
JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-$TRAVIS_CPU_ARCH-$TRAVIS_OS_NAME-jdk.deb"

echo "Building for OpenCV $OPENCV_VERSION-$OPENCV_OPNP_REV on: \n `uname -a` \n"

# Apply JNI Debian hacks, avoids OpenCV's cmake going:
# "Could NOT find JNI (missing: JAVA_AWT_LIBRARY JAVA_JVM_LIBRARY JAVA_INCLUDE_PATH ...)"
if [[ $TRAVIS_OS_NAME == "linux" ]]
then
	ls -alh /usr/lib/*-gnu/jni/*
	sudo ln -sf /usr/lib/$TRAVIS_CPU_ARCH-linux-gnu/jni/libjnidispatch.system.so \
				/usr/lib/$TRAVIS_CPU_ARCH-linux-gnu/jni/libjnidispatch.so
	
	export LD_LIBRARY_PATH=/usr/lib/$TRAVIS_CPU_ARCH-linux-gnu/jni
fi

# Get and install a proper JVM and deps per OS
case $TRAVIS_CPU_ARCH in
	amd64)
		case "$TRAVIS_OS_NAME" in
			osx)		
						JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-x64-macos-jdk.pkg"
						wget $JVM_URL && sudo installer -pkg amazon-corretto-11-x64-macos-jdk.pkg -target / && rm *.pkg
						export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/
						;;
			windows)
						# rm "/c/ProgramData/chocolatey/bin/python2.exe"
						# rm "/c/ProgramData/chocolatey/bin/python2.7.exe"
						# rm "/c/ProgramData/chocolatey/bin/python.exe"
						# rm -rf "/c/Python27"
						choco install -y ant
						choco install -y corretto11jdk --version 11.0.7.10
						#cat "C:\ProgramData\chocolatey\logs\chocolatey.log"
						export JAVA_HOME="/c/Program Files/Amazon Corretto/jdk11.0.7_10"
						export ANT_HOME="/c/ProgramData/chocolatey/lib/ant"
						export PATH="/c/Python37:/c/Python37/Scripts:/c/Program Files/Amazon Corretto/jdk11.0.7_10/bin:$PATH"
						refreshenv
						java -version
						python3 --version
						;;
			linux)		
						JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-x64-$TRAVIS_OS_NAME-jdk.deb"
						wget $JVM_URL && sudo dpkg -i *.deb && rm *.deb
						export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
						;;
		esac
		;;

	arm64)
		JVM_URL="https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-$TRAVIS_OS_NAME-jdk.deb"
		wget $JVM_URL && sudo dpkg -i *.deb && rm *.deb
		;;
esac


# Prepare by creating target dirs
echo "Create target dirs for $TRAVIS_CPU_ARCH"
./create-targets.sh $1 && pwd

cd opencv-$OPENCV_VERSION/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
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

find ../.. -iname "Makefile"
make -j8

echo "Copy OpenCV resources\n"
cd $TRAVIS_BUILD_DIR && ./copy-resources.sh $OPENCV_VERSION

# XXX: This is not needed at all if we already have the bins, right?
#mvn clean test
