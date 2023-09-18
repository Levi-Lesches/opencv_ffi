# OpenCV FFI

This package contains an ffi-based implementation of OpenCV in Dart. That is, OpenCV itself is bundled in this repository (as a submodule, in `src/opencv`), and must be built first for this package to work.

You can compile OpenCV on any platform, but the process is much simpler on Windows:

1. Install Visual Studio. You'll likely already have done this since it's required for Flutter for Windows.
2. Run `winbuild.bat`. You'll need to run it with `cmake` in your path. You can use the `Developer Command Prompt for Visual Studio`, which you can find in your path. 
3. OpenCV will be compiled and a few DLLs will be placed in `dist`. This should only take around 5 minutes.
4. Copy the DLLs to your package's root directory or in your PATH, as Dart/Pub won't be able to find them otherwise.

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

See the [docs](https://levi-lesches.github.io/OpenCV-FFI/opencv_ffi/opencv_ffi-library.html) for more usage.
