import "dart:ffi";
import "dart:typed_data";

import "ffi.dart";

/// A pointer to an image encoded by OpenCV.
///
/// Since the image is copied into a native buffer, you must keep a pointer to it until we are done
/// with it. This class holds the pointer and allows you to access its data as a [Uint8List].
///
/// When you are done with this image, be sure to call [dispose].
class OpenCVImage {
  /// The pointer to the native buffer containing this image.
  final Pointer<Uint8> pointer;

  /// The data stored in the native buffer, in Dart format.
  ///
  /// This data is not copied but rather taken from native memory directly.
  final Uint8List data;

  /// Holds a pointer to an image encoded by OpenCV.
  OpenCVImage({required this.pointer, required int length}) :
    data = pointer.asTypedList(length);

  /// Frees the resources associated with this image.
  void dispose() => nativeLib.freeImage(pointer);
}
