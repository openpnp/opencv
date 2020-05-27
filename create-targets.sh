VERSION=$1
SHORT_VERSION=`echo $VERSION | tr -d .`
BASE_DIR=$PWD

echo "Version: $VERSION"
echo "Short Version: $SHORT_VERSION"
echo "Base Dir: $BASE_DIR"

mkdir $BASE_DIR/target
mkdir $BASE_DIR/target/linux
mkdir $BASE_DIR/target/linux/x86_64
mkdir $BASE_DIR/target/linux/ARMv8
mkdir $BASE_DIR/target/osx
mkdir $BASE_DIR/target/osx/x86_64
mkdir $BASE_DIR/target/windows
