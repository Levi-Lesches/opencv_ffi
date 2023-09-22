@echo off

rem Check if CMake is not on the path
where cmake 1>NUL 2>NUL
if errorlevel 1 (
	echo You must run this script with cmake on your PATH
	echo The easiest way to do this is to install Visual Studio, which you did if you're using Flutter for Windows,
	echo and run this script from the Developer Command Prompt for Visual Studio. Search that in your Start menu.
	exit /b 1
)

git submodule update --init --recursive
if errorlevel 1 (
	echo Could not clone OpenCV. Check your internet connection and try again.
	echo You can also do this manually with ^"git submodule update --init --recursive^"
)

rem Build OpenCV and opencv_ffi
if not exist build mkdir build
cd build
cmake ../src
cmake --build .
cd ..

rem Copy DLLs to the dist directory
if not exist dist mkdir dist
copy build\bin\Debug\*.dll dist
copy build\Debug\*.dll dist

echo:
echo Done! Your files are in the dist folder. Add this directory to your PATH:
echo %cd%\dist
echo You can edit your PATH by entering ^"Edit the system environment variables^" in the Start Menu
