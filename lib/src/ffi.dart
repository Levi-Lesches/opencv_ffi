import "dart:ffi";

import "generated/opencv_ffi_bindings.dart";
export "generated/opencv_ffi_bindings.dart";

const path = "build/opencv_ffi.dll";
final lib = DynamicLibrary.open(path);
final bindings = OpenCVBindings(lib);
