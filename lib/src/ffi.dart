import "dart:io";
import "dart:ffi";
import "generated/opencv_ffi_bindings.dart";

export "generated/opencv_ffi_bindings.dart";

/// Gets the path to the `opencv_ffi` library, depending on the current platform.
String _getPath() {
  if (Platform.isWindows) {
    return "opencv_ffi.dll";
  } else if (Platform.isMacOS) {
    return "libopencv_ffi.dylib";
  } else if (Platform.isLinux) {
    return "libopencv_ffi.so";
  } else {
    throw UnsupportedError("Unsupported platform");
  }
}

/// The C bindings generated by `package:ffigen`.
final nativeLib = OpenCVBindings(DynamicLibrary.open(_getPath()))
  ..setLogLevel(0); // 0 = silent
