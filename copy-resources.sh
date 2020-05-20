VERSION=$1
SHORT_VERSION=`echo $VERSION | tr -d .`
BASE_DIR=opencv-$VERSION

MACHINE_NAME=`uname -m`	# x86_64, aarch64...
OS_NAME=`uname -s`		# Darwin, Linux...

echo "Version: $VERSION"
echo "Short Version: $SHORT_VERSION"
echo "Base Dir: $BASE_DIR"

# Java
echo "Cleaning up Java..."
rm -f upstream/*.jar
rm -rf upstream/res/*

case "$OS_NAME" in
	Darwin)
		# OSX
		# We don't care about 32-bit OSX for now
		echo "Copying Java OSX jars..."
		cp $BASE_DIR/target/osx/x86_64/bin/opencv-$SHORT_VERSION.jar upstream
		cp $BASE_DIR/target/osx/x86_64/java_test/build/jar/opencv-test.jar upstream
		cp -r $BASE_DIR/target/osx/x86_64/java_test/res/* upstream/res
		echo "Cleaning up OSX..."
		rm -f src/main/resources/nu/pattern/opencv/osx/x86_64/cmake.log
		rm -f src/main/resources/nu/pattern/opencv/osx/x86_64/*.dylib
		echo "Copying OSX..."
		cp $BASE_DIR/target/osx/x86_64/cmake.log src/main/resources/nu/pattern/opencv/osx/x86_64
		cp $BASE_DIR/target/osx/x86_64/lib/libopencv_java$SHORT_VERSION.dylib \
		   src/main/resources/nu/pattern/opencv/osx/x86_64
	;;
	Linux)
		case "$MACHINE_NAME" in
			x86_64)
				echo "Cleaning up Linux x86_64..."
				rm -f src/main/resources/nu/pattern/opencv/linux/x86_64/cmake.log
				rm -f src/main/resources/nu/pattern/opencv/linux/x86_64/*.so
				echo "Copying Linux x86_64..."
				cp $BASE_DIR/target/linux/x86_64/cmake.log \
				   src/main/resources/nu/pattern/opencv/linux/x86_64
				cp $BASE_DIR/target/linux/x86_64/lib/libopencv_java$SHORT_VERSION.so \
				   src/main/resources/nu/pattern/opencv/linux/x86_64
			;;
			aarch64)
				echo "Cleaning up Linux ARMv8..."
				rm -f src/main/resources/nu/pattern/opencv/linux/ARMv8/*.so
				echo "Copying Linux ARMv8..."
				cp $BASE_DIR/target/linux/ARMv8/lib/libopencv_java$SHORT_VERSION.so \
				   src/main/resources/nu/pattern/opencv/linux/ARMv8
				;;
		esac
	;;
	Windows)
		# Windows
		echo "Cleaning up Windows..."
		rm -f src/main/resources/nu/pattern/opencv/windows/x86_32/*.dll
		rm -f src/main/resources/nu/pattern/opencv/windows/x86_64/*.dll
		echo "Copying Windows..."
		cp $BASE_DIR/target/windows/opencv/build/java/x86/opencv_java$SHORT_VERSION.dll \
		   src/main/resources/nu/pattern/opencv/windows/x86_32
		cp $BASE_DIR/target/windows/opencv/build/java/x64/opencv_java$SHORT_VERSION.dll \
		   src/main/resources/nu/pattern/opencv/windows/x86_64
	;;
	*)
		echo "Unknown OS detected"
	;;
esac
