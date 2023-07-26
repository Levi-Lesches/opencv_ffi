import "dart:io";
import "dart:ffi";
import "package:ffi/ffi.dart";

import "exceptions.dart";
import "ffi.dart";
import "image.dart";

/// Opens and accesses a camera attached to your device.
/// 
/// Check if the camera is available using [isOpened], then: 
/// - Show the current frame on-screen using [showFrame]
/// - Get a JPG using [getJpg]
/// - Save a JPG to a file using [saveJpg]
/// 
/// Be sure to call [dispose] to release the camera.
class Camera {
	/// An arena to allocate native memory. Call `_arena<T>()` to do so.
	final _arena = Arena();

	/// A pointer to the native [VideoCapture] object. Can only be used by OpenCV.
	final Pointer<VideoCapture> _camera;

	/// A pointer to the current frame. Can only be used by OpenCV.
	final Pointer<Mat> _image = nativeLib.Mat_create();

	/// Opens the camera at the given [index].
	Camera.fromIndex(int index) : _camera = nativeLib.VideoCapture_getByIndex(index);

	/// Opens the camera with the given [name].
	/// 
	/// This name is the path to a device file, such as `/dev/video0`. This is not supported on Windows.
	Camera.fromName(String name) : _camera = nativeLib.VideoCapture_getByName(name.toNativeUtf8().cast<Char>());

	/// Reads the current frame, throwing a [CameraReadException] if it fails.
	void _read() {
		final result = nativeLib.VideoCapture_read(_camera, _image);
		if (result == 0) throw CameraReadException();
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

	/// Reads a frame from the camera and shows it to the screen.
	/// 
	/// The resulting window is controlled by OpenCV, so only use this for testing.
	void showFrame() {
		_read();
		nativeLib.imshow(_image);
	}

	/// Returns an [OpenCVImage] representing a JPG frame captured at the given [quality].
	OpenCVImage getJpg({int quality = 75}) {
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
		_read();
		final Pointer<Pointer<Uint8>> bufferAddress = _arena<Pointer<Uint8>>();  // (1)
		final size = nativeLib.encodeJpg(_image, quality, bufferAddress);  // (2)
		if (size == 0) throw ImageEncodeException();
		final Pointer<Uint8> buffer = bufferAddress.value;  // (3)
		return OpenCVImage(pointer: buffer, length: size);
	}

	/// Saves the current frame as a JPG to the given [file]. 
	/// 
	/// This function allocates and disposes of an [OpenCVImage] for you.
	Future<void> saveJpg(File file, {int quality = 75}) async {
		final OpenCVImage jpg = getJpg(quality: quality);
		await file.writeAsBytes(jpg.data, flush: true);
		jpg.dispose();
	}
}
