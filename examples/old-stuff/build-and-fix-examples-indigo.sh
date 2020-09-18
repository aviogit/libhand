#!/bin/bash

# libHand can be found here: https://github.com/jonkeane/libhand

CURR_PWD=`pwd`
BASE_DIR="${CURR_PWD%%examples}"

#echo $CURR_PWD
#echo $BASE_DIR
#exit 0

HAND_CPP_BUILD_DIR="$BASE_DIR/hand_cpp/build"
HAND_CPP_BUILD_SRC_DIR="$HAND_CPP_BUILD_DIR/source"

CMAKE_EXPORT=`find "$HAND_CPP_BUILD_SRC_DIR" -name 'LibHand-export.cmake'`

echo "Creating symlinks..."

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

LIBOPENCV_INDIGO_PATH="/usr/lib/x86_64-linux-gnu/libopencv_"
LIBOPENCV_INDIGO_SUFFIX=".2.4.8"

find . -name 'link.txt' -exec sed -i 's: hand_\(.*\)-NOTFOUND: -L '"$BASE_DIR"'/hand_cpp/build/source -lhand_hog -lhand_renderer -lhand_utils -ldl -lXt -lboost_system '"$LIBOPENCV_INDIGO_PATH"'videostab.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'ts.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'superres.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'stitching.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'contrib.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'nonfree.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'ocl.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'gpu.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'photo.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'objdetect.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'legacy.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'video.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'ml.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'calib3d.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'features2d.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'highgui.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'imgproc.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'flann.so'"$LIBOPENCV_INDIGO_SUFFIX"' '"$LIBOPENCV_INDIGO_PATH"'core.so'"$LIBOPENCV_INDIGO_SUFFIX"' -ldot_sceneloader -ltinyxml -lOgreMain -lboost_thread -lboost_date_time -lboost_system -lboost_atomic -lboost_chrono -lpthread -lOgreMain -lboost_thread -lboost_date_time -lboost_system -lboost_atomic -lboost_chrono -lpthread:g' {} \;

echo "Ok, if no error has been encountered, you should now be able to build safely..."
