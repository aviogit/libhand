CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6)

PROJECT(LibHand_Examples)

FIND_PACKAGE(LibHand REQUIRED
  PATHS "../dist"
  NO_MODULE
  NO_DEFAULT_PATH)

IF(WIN32)
  SET(OpenCV_DIR "C:/OpenCV249/opencv/build")
  FIND_PACKAGE(OpenCV REQUIRED)
ENDIF()

IF(UNIX OR APPLE)
  FIND_PACKAGE(Boost COMPONENTS thread date_time REQUIRED)
  INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
  LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})
ENDIF()

if(NOT Boost_FOUND)
	MESSAGE(FATAL_ERROR "Boost was not found!")
endif()

MESSAGE("Boost libraries: ${Boost_LIBRARIES}")
MESSAGE("LibHand libraries: ${LibHand_LIBRARIES}")

INCLUDE_DIRECTORIES(${LibHand_INCLUDE_DIRS})

ADD_EXECUTABLE(bend_one_finger bend_one_finger.cc)
TARGET_LINK_LIBRARIES(bend_one_finger ${LibHand_LIBRARIES} ${OpenCV_LIBS})

ADD_EXECUTABLE(render_hog_descriptor render_hog_descriptor.cc)
TARGET_LINK_LIBRARIES(render_hog_descriptor ${LibHand_LIBRARIES} ${OpenCV_LIBS})

ADD_EXECUTABLE(file_dialog_test file_dialog_test.cc)
TARGET_LINK_LIBRARIES(file_dialog_test hand_utils)

ADD_EXECUTABLE(ogre_rendering_test ogre_rendering_test.cc)
TARGET_LINK_LIBRARIES(ogre_rendering_test ${LibHand_LIBRARIES})

ADD_EXECUTABLE(show_gestures show_gestures.cpp)
TARGET_LINK_LIBRARIES(show_gestures ${LibHand_LIBRARIES} ${Boost_LIBRARIES})
SET_TARGET_PROPERTIES(show_gestures PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g3 -O0 -Wall ")

ADD_EXECUTABLE(show_gestures_two_hands show_gestures_two_hands.cpp)
TARGET_LINK_LIBRARIES(show_gestures_two_hands ${LibHand_LIBRARIES} ${Boost_LIBRARIES})
SET_TARGET_PROPERTIES(show_gestures_two_hands PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g3 -O0 -Wall ")

ADD_EXECUTABLE(h_movement h_movement.cpp)
TARGET_LINK_LIBRARIES(h_movement ${LibHand_LIBRARIES} ${Boost_LIBRARIES})
SET_TARGET_PROPERTIES(h_movement PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g3 -O0 -Wall ")

