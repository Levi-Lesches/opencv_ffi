#!/bin/bash

# Find CMake and warn if it's not installed
CMAKE_PATH=`which cmake`
if [ -z "$CMAKE_PATH" ]; then
	echo CMake could not be found. Please install it by running
	echo sudo apt install cmake
	exit 1
fi

# Build OpenCV and opencv_ffi
mkdir -p build  # -p means no error if there
cd build
cmake ../src
cmake --build . -j8
cd ..

# Copy the .so files to the .dist directory
mkdir -p dist
cp XXX/*.so dist  # the OpenCV libraries
cp XXX/*.so dist  # the opencv_ffi library

echo Done! Your files are in the dist folder
echo Copy these to the root of whatever project you use opencv_ffi in
