import "dart:ffi";
import "package:ffi/ffi.dart";

import "exceptions.dart";
import "ffi.dart";
import "image.dart";

/// Opens and accesses a camera attached to your device.
///
/// On Windows, use the camera index with [Camera.fromIndex]. On Mac and Linux, use the camera name
/// with [Camera.fromName]. The [udev](https://wiki.archlinux.org/title/udev) tool can be used to
/// ensure that a camera retains the same name regardless of which port it is plugged into or the
/// order it was plugged in.
///
/// Check if the camera is available using [isOpened], then:
/// - Show the current frame on-screen using [showFrame]
/// - Get a JPG using [getJpg]
/// - Be sure to call [dispose] to release the camera.
/// 
/// This class also lets you set value for specific settings that may or may not be supported by
/// your device. To find which values are supported, run the following command (Linux only):
/// ```bash
/// v4l2-ctl -d 0 -l
/// ```
/// 
/// On Windows, you can use FFMPEG to check the camera's supported options. This class supports
/// resolution, zoom, focus, autofocus, pan, tilt, and roll. Additional options can be set using
/// [setProperty] and [getProperty].
class Camera {
  /// An arena to allocate native memory. Call `_arena<T>()` to do so.
  final _arena = Arena();

  /// A pointer to the native [VideoCapture] object. Can only be used by OpenCV.
  final Pointer<VideoCapture> _camera;

  /// A pointer to the current frame. Can only be used by OpenCV.
  final Pointer<Mat> _image = nativeLib.Mat_create();

  /// Opens the camera at the given [index].
  Camera.fromIndex(int index)
      : _camera = nativeLib.VideoCapture_getByIndex(index);

  /// Opens the camera with the given [name].
  ///
  /// This name is the path to a device file, such as `/dev/video0`. This is not supported on Windows.
  Camera.fromName(String name)
      : _camera = nativeLib.VideoCapture_getByName(name.toNativeUtf8());

  /// Reads the current frame, and returns true if successful.
  ///
  /// This function updates [_image]. If it is not called, other functions such as [showFrame]
  /// or [getJpg] will use the last read frame, or a blank frame.
  bool _read() {
    final result = nativeLib.VideoCapture_read(_camera, _image);
    return result != 0;
  }

  /// Frees the native resources used by this camera.
  void dispose() {
    nativeLib
      ..VideoCapture_release(_camera)
      ..VideoCapture_destroy(_camera)
      ..Mat_destroy(_image);
    _arena.releaseAll();
  }

  /// Whether this camera is opened. If the device is not connected, this will be false.
  bool get isOpened => nativeLib.VideoCapture_isOpened(_camera) != 0;

  /// Sets a property of the camera. 
  /// 
  /// See https://docs.opencv.org/3.4/d4/d15/group__videoio__flags__base.html#gaeb8dd9c89c10a5c63c139bf7c4f5704d
  void setProperty(int propertyID, int value) => 
    nativeLib.VideoCapture_setProperty(_camera, propertyID, value);
  
  /// Reads a property of the camera. 
  /// 
  /// See https://docs.opencv.org/3.4/d4/d15/group__videoio__flags__base.html#gaeb8dd9c89c10a5c63c139bf7c4f5704d
  int getProperty(int propertyID) => nativeLib.VideoCapture_getProperty(_camera, propertyID);

  /// Sets the resolution of the camera.
  void setResolution(int width, int height) {
    setProperty(3, width);  // cv::CAP_PROP_FRAME_WIDTH = 3,
    setProperty(4, height); // cv::CAP_PROP_FRAME_HEIGHT = 4,
  }

  /// The native framerate of the camera. This is different than reading frames at an interval.
  int get fps => getProperty(5);
  set fps(int value) => setProperty(5, value);
  
  /// The zoom level of the camera. 
  int get zoom => getProperty(27);
  set zoom(int value) => setProperty(27, value);
  
  /// The focus of the camera.
  int get focus => getProperty(28);
  set focus(int value) => setProperty(28, value);

  /// Pans the camera when zoomed in.
  int get pan => getProperty(33);
  set pan(int value) => setProperty(33, value);
  
  /// Tilts the camera vertically when zoomed in.
  int get tilt => getProperty(34);
  set tilt(int value) => setProperty(34, value);

  /// Rolls the camera when zoomed in.
  int get roll => getProperty(35);
  set roll(int value) => setProperty(35, value);
  
  /// Reads a frame from the camera and shows it to the screen.
  ///
  /// The resulting window is controlled by OpenCV, so only use this for testing.
  void showFrame() {
    if (!_read()) throw CameraReadException();
    nativeLib.imshow(_image);
  }

  /// Returns an [OpenCVImage] representing a JPG frame captured at the given [quality].
  ///
  /// Returns `null` if the camera could not be read.
  OpenCVImage? getJpg({int quality = 75}) {
    // The native function needs to return a variable-length buffer. If we allocate the buffer on
    // the Dart side, before reading the image, it may end up being too small. So we need to wait
    // until after the image has been read, on the native side, to allocate an appropriate buffer.
    //
    // Our workaround is to pass a pointer to a pointer to a buffer, instead of just the pointer
    // itself. In other words, a `uint8_t**`. This way, the native function can set the pointer
    // to point to a buffer _it_ allocates after reading the image, and we can read the address.
    // The only caveat is that since the buffer is allocated natively, we must keep a pointer
    // to it so we can free it natively too, not from Dart.
    //
    // 1. Allocate a pointer to a pointer.
    // 2. Call the native function and pass the pointer to the pointer.
    // 3. The pointer now points to a valid pointer, which points to the actual buffer.
    final didRead = _read();
    if (!didRead) return null;
    final bufferAddress = _arena<Pointer<Uint8>>(); // (1)
    final size = nativeLib.encodeJpg(_image, quality, bufferAddress); // (2)
    if (size == 0) throw ImageEncodeException();
    final Pointer<Uint8> buffer = bufferAddress.value; // (3)
    return OpenCVImage(pointer: buffer, length: size);
  }
}
