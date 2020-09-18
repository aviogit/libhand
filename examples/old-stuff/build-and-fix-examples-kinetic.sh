#!/bin/bash

# libHand can be found here: https://github.com/jonkeane/libhand

CURR_PWD=`pwd`
BASE_DIR="${CURR_PWD%%examples}"

#echo $CURR_PWD
#echo $BASE_DIR
#exit 0

HAND_CPP_BUILD_DIR="$BASE_DIR""hand_cpp/build"

if [ ! -d "$HAND_CPP_BUILD_DIR" ] ; then
	echo
	echo "Directory: $HAND_CPP_BUILD_DIR does not exist. Please first build hand_cpp doing standard \"mkdir build ; cd build ; cmake .. ; make\" while in hand_cpp base directory."
	echo
	exit 1
fi

HAND_CPP_BUILD_SRC_DIR="$HAND_CPP_BUILD_DIR/source"

CMAKE_EXPORT=`find "$HAND_CPP_BUILD_SRC_DIR" -name 'LibHand-export.cmake'`

echo "Creating symlinks..."

#find: ‘/mnt/data/workspace/ros/src/hand/libhand//hand_cpp/build/source’: No such file or directory
#Creating symlinks...
#ln: failed to create symbolic link '/mnt/data/workspace/ros/src/hand/libhand//hand_cpp/build/source/LibHand-export.cmake' -> '': No such file or directory
#ln: failed to create symbolic link '/mnt/data/workspace/ros/src/hand/libhand//hand_cpp/build/source/libtinyxml.a': No such file or directory
#ln: failed to create symbolic link '/mnt/data/workspace/ros/src/hand/libhand//hand_cpp/build/source/libdot_sceneloader.a': No such file or directory


ln -s "$CMAKE_EXPORT" "$HAND_CPP_BUILD_SRC_DIR"/LibHand-export.cmake
ln -s "$HAND_CPP_BUILD_SRC_DIR"/dot_sceneloader/tinyxml/libtinyxml.a "$HAND_CPP_BUILD_SRC_DIR"/libtinyxml.a
ln -s "$HAND_CPP_BUILD_SRC_DIR"/dot_sceneloader/libdot_sceneloader.a "$HAND_CPP_BUILD_SRC_DIR"/libdot_sceneloader.a 

echo "Creating and entering build directory..."

mkdir build
cd build
cmake -DCMAKE_CXX_COMPILER=/usr/bin/g++ -DCMAKE_C_COMPILER=/usr/bin/gcc -DLibHand_DIR="$BASE_DIR"/hand_cpp/build/source ..
cd ..

echo "Leaving build directory.."

echo "Fixing makefiles..."

find . -name build.make -exec sed -i 's:.*-NOTFOUND::g' {} \;

#/opt/ros/kinetic/lib/libopencv_superres3.so.3.2.0

#g++: error: /opt/ros/kinetic/lib/libopencv_ts3.so.3.2.0: No such file or directory
#g++: error: /opt/ros/kinetic/lib/libopencv_contrib3.so.3.2.0: No such file or directory
#g++: error: /opt/ros/kinetic/lib/libopencv_nonfree3.so.3.2.0: No such file or directory
#g++: error: /opt/ros/kinetic/lib/libopencv_ocl3.so.3.2.0: No such file or directory
#g++: error: /opt/ros/kinetic/lib/libopencv_gpu3.so.3.2.0: No such file or directory
#g++: error: /opt/ros/kinetic/lib/libopencv_legacy3.so.3.2.0: No such file or directory


LIBOPENCV_INDIGO_PATH="/usr/lib/x86_64-linux-gnu/libopencv_"
LIBOPENCV_INDIGO_SUFFIX=".so.2.4.8"
LIBOPENCV_KINETIC_PATH="/opt/ros/kinetic/lib/libopencv_"
LIBOPENCV_KINETIC_SUFFIX="3.so.3.2.0"

OPENCV_LIB_LIST_INDIGO="videostab ts superres stitching contrib nonfree ocl gpu photo objdetect legacy video ml calib3d features2d highgui imgproc flann core"
OPENCV_LIB_LIST_KINETIC="videostab superres stitching photo objdetect optflow video ml calib3d features2d highgui imgproc flann core"

OPENCV_LIB_STR=""

for item in $OPENCV_LIB_LIST_KINETIC
do
	#echo $item
	OPENCV_LIB_STR="$OPENCV_LIB_STR $LIBOPENCV_KINETIC_PATH$item$LIBOPENCV_KINETIC_SUFFIX"
done

#echo $OPENCV_LIB_STR

find . -name 'link.txt' -exec sed -i 's: hand_\(.*\)-NOTFOUND: -L '"$BASE_DIR"'/hand_cpp/build/source -lhand_hog -lhand_renderer -lhand_utils -ldl -lXt -lboost_system '"$OPENCV_LIB_STR"' -ldot_sceneloader -ltinyxml -lOgreMain -lboost_thread -lboost_date_time -lboost_system -lboost_atomic -lboost_chrono -lpthread -lOgreMain -lboost_thread -lboost_date_time -lboost_system -lboost_atomic -lboost_chrono -lpthread:g' {} \;

echo "Ok, if no error has been encountered, you should now be able to build safely..."
