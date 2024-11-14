> [!important]
> This package is discontinued in favor of [`package:opencv_dart`](https://pub.dev/packages/opencv_dart) as it is similar but more feature complete and under active maintenance. 

# OpenCV FFI

This package contains an ffi-based implementation of OpenCV in Dart. That is, OpenCV itself is bundled in this repository (as a submodule, in `src/opencv`), and must be built first for this package to work.

## Compiling OpenCV

This plugin dynamically loads shared/dynamic libraries to run, namely, OpenCV. For now, you must compile OpenCV yourself using the build scripts provided here. They have been hand-tuned to build only what's needed by this plugin to reduce build time from a few hours to a few minutes. This means that even if you include this plugin in your `pubspec.yaml`, you still need to manually clone this repository to build OpenCV and produce the `.so` or `.dll` files. 

In the future, this process will use the upcoming [Native Assets feature](https://github.com/dart-lang/sdk/issues/50565), which will allow `dart pub get` to do this automatically.  

### Windows

1. Install CMake, or Visual Studio with CMake. You'll likely already have done this since it's required for Flutter for Windows.
2. Add CMake to your `PATH` and restart your terminal/IDE. You can also use the `Developer Command Prompt for Visual Studio`.
3. Verify CMake is available by running `cmake --version`
4. Run `build.bat` to compile OpenCV and generate the `dist` folder. This should take up to 5 minutes depending on your PC
6. Add the `dist` folder to your `PATH`. Restart your terminal/IDE and run your project as normal.

### Linux

Run `build.sh`. This will compile OpenCV and can take up to 10 minutes depending on your hardware. The script will output a command to add the `dist` folder to your `LD_LIBRARY_PATH`. You only need to run this command once, even if you modify and rebuild OpenCV, but you must run it again if you _move_ the `dist` folder. 

## Usage

```dart
import "package:opencv_ffi/opencv_ffi.dart";

void main() async {
  final camera = Camera(0);
  try {
    while (true) {
      camera.showFrame();
    }
  } finally {
    camera.dispose();    
  }
}
```

See the [docs](https://levi-lesches.github.io/opencv_ffi/opencv_ffi/opencv_ffi-library.html) for more usage.
