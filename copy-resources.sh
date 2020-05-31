#!/bin/bash -x

VERSION=$1
SHORT_VERSION=`echo $VERSION | tr -d .`
BASE_DIR=opencv-$VERSION

echo "Version: $VERSION"
echo "Short Version: $SHORT_VERSION"
echo "Base Dir: $BASE_DIR"

# Java
echo "Cleaning up Java..."
rm -f upstream/*.jar
rm -rf upstream/res/*

echo "OpenCV TEST JAR is in: "
find $BASE_DIR -type f -iname "opencv-test.jar"

case "$TRAVIS_OS_NAME" in
	osx)
		find $BASE_DIR -type f -iname "*.dylib"
		# OSX
		#echo "Copying Java OSX jars..."
		#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/bin/opencv-$SHORT_VERSION.jar upstream
		#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/java_test/build/jar/opencv-test.jar upstream
		#cp -r $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/java_test/res/* upstream/res
		echo "Cleaning up OSX..."
		rm -f src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/cmake.log
		rm -f src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/*.dylib
		#echo "Copying OSX..."
		#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/cmake.log src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
		#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java$SHORT_VERSION.dylib \
		#   src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
	;;
	linux)
		case "$TRAVIS_CPU_ARCH" in
			$TRAVIS_CPU_ARCH)
				echo "Copying Linux $TRAVIS_CPU_ARCH..."
				find $BASE_DIR -type f -iname "*_java*.so"
				#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/cmake.log \
				#   src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
				#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java$SHORT_VERSION.so \
				#   src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
			;;
			aarch64)
				echo "Cleaning up Linux $TRAVIS_CPU_ARCH..."
				rm -f src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/*.so
				echo "Copying Linux $TRAVIS_CPU_ARCH..."
				find $BASE_DIR -type f -iname "*_java*.so"
				#cp $BASE_DIR/target/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH/lib/libopencv_java$SHORT_VERSION.so \
				#   src/main/resources/nu/pattern/opencv/$TRAVIS_OS_NAME/$TRAVIS_CPU_ARCH
				;;
		esac
	;;
	windows)
		find $BASE_DIR -type f -iname "*_java*.dll"
		# Windows
		#echo "Cleaning up Windows..."
		#rm -f src/main/resources/nu/pattern/opencv/windows/x86_32/*.dll
		#rm -f src/main/resources/nu/pattern/opencv/windows/$TRAVIS_CPU_ARCH/*.dll
		#echo "Copying Windows..."
		#cp $BASE_DIR/target/windows/opencv/build/java/x86/opencv_java$SHORT_VERSION.dll \
		#   src/main/resources/nu/pattern/opencv/windows/x86_32
		#cp $BASE_DIR/target/windows/opencv/build/java/x64/opencv_java$SHORT_VERSION.dll \
		#   src/main/resources/nu/pattern/opencv/windows/$TRAVIS_CPU_ARCH
	;;
	*)
		echo "Unknown OS detected"
		exit -1
	;;
esac
