# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.

# Config for CMake
cmake_minimum_required(VERSION 3.10)
project(opencv_ffi_library VERSION 0.0.1 LANGUAGES CXX)

# OpenCV config. These only build the stuff we need to reduce build time
remove_definitions(-DUNICODE -D_UNICODE)
SET(BUILD_TESTS OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_PERF_TESTS OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_EXAMPLES OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_opencv_apps OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_LIST "core,videoio,highgui,objdetect" CACHE STRING "Some option" FORCE)
SET(BUILD_JAVA OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_opencv_python2 OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_opencv_python3 OFF CACHE BOOL "Some option" FORCE)
# Disable OpenCL additions
SET(WITH_OPENCL OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENCL_SVM OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENCLAMDFFT OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENCLAMDBLAS OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENCL_D3D11_NV OFF CACHE BOOL "Some option" FORCE)
SET(WITH_VA_INTEL OFF CACHE BOOL "Some option" FORCE)
# Disable unneeded image codecs
SET(WITH_IMGCODEC_HDR OFF CACHE BOOL "Some option" FORCE)
SET(WITH_IMGCODEC_SUNRASTER OFF CACHE BOOL "Some option" FORCE)
SET(WITH_IMGCODEC_PXM OFF CACHE BOOL "Some option" FORCE)
SET(WITH_IMGCODEC_PFM OFF CACHE BOOL "Some option" FORCE)
SET(WITH_PNG OFF CACHE BOOL "Some option" FORCE)
SET(WITH_TIFF OFF CACHE BOOL "Some option" FORCE)
SET(WITH_WEBP OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENJPEG OFF CACHE BOOL "Some option" FORCE)
SET(WITH_JASPER OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENEXR OFF CACHE BOOL "Some option" FORCE)
# Disable unneeded video IO modules
SET(WITH_FFMPEG OFF CACHE BOOL "Some option" FORCE)
SET(WITH_GSTREAMER OFF CACHE BOOL "Some option" FORCE)
SET(WITH_DSHOW OFF CACHE BOOL "Some option" FORCE)
SET(WITH_1394 OFF CACHE BOOL "Some option" FORCE)
SET(WITH_ITT OFF CACHE BOOL "Some option" FORCE)
SET(WITH_ANDROID_MEDIANDK OFF CACHE BOOL "Some option" FORCE)
SET(VIDEOIO_ENABLE_PLUGINS OFF CACHE BOOL "Some option" FORCE)
# Disable unneeded GUI features
SET(HIGHGUI_ENABLE_PLUGINS OFF CACHE BOOL "Some option" FORCE)
# Disable unneeded Deep Neural Networks features
SET(WITH_PROTOBUF OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_PROTOBUF OFF CACHE BOOL "Some option" FORCE)
SET(OPENCV_DNN_OPENCL OFF CACHE BOOL "Some option" FORCE)
# Misc. optimizations
SET(ENABLE_LTO ON CACHE BOOL "Some option" FORCE)
SET(ENABLE_PYLINT OFF CACHE BOOL "Some option" FORCE)
SET(ENABLE_FLAKE8 OFF CACHE BOOL "Some option" FORCE)
SET(WITH_CAROTENE OFF CACHE BOOL "Some option" FORCE)
SET(WITH_EIGEN OFF CACHE BOOL "Some option" FORCE)
SET(WITH_OPENVX OFF CACHE BOOL "Some option" FORCE)
SET(WITH_DIRECTX OFF CACHE BOOL "Some option" FORCE)
SET(WITH_VA OFF CACHE BOOL "Some option" FORCE)
SET(WITH_LAPACK OFF CACHE BOOL "Some option" FORCE)
SET(WITH_QUIRC OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_ZLIB OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_ITT OFF CACHE BOOL "Some option" FORCE)
SET(WITH_IPP OFF CACHE BOOL "Some option" FORCE)
SET(BUILD_IPP_IW OFF CACHE BOOL "Some option" FORCE)

include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}/opencv/modules/videoio/include")
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}/opencv/modules/core/include")
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}/opencv/modules/highgui/include")
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}/opencv/modules/imgcodecs/include")
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_SOURCE_DIR}/opencv/modules/objdetect/include")
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_BINARY_DIR}/opencv/include")
include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_BINARY_DIR}/")

# Compile OpenCV and register with CMake
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_subdirectory(opencv)

# Config for opencv_ffi
add_library(opencv_ffi SHARED "opencv_ffi.cpp")
set_target_properties(opencv_ffi PROPERTIES
  PUBLIC_HEADER opencv_ffi.h
  OUTPUT_NAME "opencv_ffi"
)

# Compile opencv_ffi
target_compile_definitions(opencv_ffi PUBLIC DART_SHARED_LIB)
target_link_libraries( opencv_ffi "opencv_videoio" "opencv_highgui" "opencv_core" "opencv_objdetect")
