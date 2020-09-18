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

find . -name 'link.txt' -exec sed -i 's: hand_\(.*\)-NOTFOUND: -L '"$BASE_DIR"'/hand_cpp/build/source -lhand_hog -lhand_renderer -lhand_utils -ldl -lXt -lboost_system /usr/lib/x86_64-linux-gnu/libopencv_videostab.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_ts.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_superres.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_stitching.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_contrib.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_nonfree.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_ocl.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_gpu.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_photo.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_objdetect.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_legacy.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_video.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_ml.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_calib3d.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_features2d.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_highgui.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_imgproc.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_flann.so.2.4.8 /usr/lib/x86_64-linux-gnu/libopencv_core.so.2.4.8 -ldot_sceneloader -ltinyxml -lOgreMain -lboost_thread -lboost_date_time -lboost_system -lboost_atomic -lboost_chrono -lpthread -lOgreMain -lboost_thread -lboost_date_time -lboost_system -lboost_atomic -lboost_chrono -lpthread:g' {} \;

echo "Ok, if no error has been encountered, you should now be able to build safely..."
