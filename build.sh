#!/bin/bash
set -e  # Any error will cause the script to fail

git submodule update --init --recursive

# Warn if CMake is not installed
CMAKE_PATH=`which cmake`
if [ -z "$CMAKE_PATH" ]; then
	echo CMake could not be found. Please install it by running
	echo sudo apt install cmake
	exit 1
fi

# Warn if cannot find OpenCV
OPENCV_DIR="./src/opencv"
if [ ! -d $OPENCV_DIR ]; then
	echo Could not find OpenCV.
	echo Make sure you are running this in the opencv_ffi package.
	exit 2
fi

# Build OpenCV and opencv_ffi
mkdir -p build  # -p means no error if there
cd build
cmake ../src
cmake --build . -j8
cd ..

# Copy the .so files to the .dist directory
mkdir -p dist
cp build/opencv/lib/*.so dist  # the OpenCV libraries
cp build/*.so dist  # the opencv_ffi library
sudo cp dist/*.so /usr/lib  # the opencv_ffi library

cd $(dirname "$0")
SCRIPT_DIR=$(pwd)
INDENT="  "

echo 
echo Done! Your files are in the dist folder, and have been copied to /usr/lib
