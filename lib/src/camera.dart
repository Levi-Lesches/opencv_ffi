import "dart:io";
import "dart:ffi";
import "dart:typed_data";
import "package:ffi/ffi.dart";

import "generated/opencv_ffi_bindings.dart";

const path = "build/opencv_ffi.dll";
final native = OpenCVBindings(DynamicLibrary.open(path));

class Camera implements Finalizable {
	final int index;
	final arena = Arena();
	late final Pointer<VideoCapture> camera;
	late final Pointer<Mat> image;

	Pointer<Uint8>? _oldFrame;

	Camera(this.index)
	{
		native.setLogLevel(0);  // 0 = silent
		camera = native.VideoCapture_getByIndex(index);
		image = native.Mat_create();
	}

	void dispose() {
		native
			..VideoCapture_release(camera)
			..VideoCapture_destroy(camera)
			..Mat_destroy(image);
		arena.releaseAll();
		if (_oldFrame != null) calloc.free(_oldFrame!);
	}

	bool get isOpened => native.VideoCapture_isOpened(camera) != 0;

	bool read() => native.VideoCapture_read(camera, image) != 0;

	void display() => native.imshow(image);

	OpenCVImage? getJpg({int quality = 75}) {
		if (!read()) return null;
		// The native function returns a variable-length buffer. 
		// To ensure enough space is allocated, we do the allocation on the native side.
		// This means that the native code cannot just populate a pre-allocated buffer,
		// but rather has to return a pointer to the buffer. Since we're already returning
		// the length, we use an out-variable for the buffer's pointer.
		// 
		// 1. Allocate enough space for a pointer, initialized to the nullptr
		// 2. Call the native function with the address of the pointer
		// 3. Lookup the new pointer at the same address
		// 4. Use that pointer to retrieve the native buffer.
		final Pointer<Pointer<Uint8>> bufferAddress = arena<Pointer<Uint8>>();  // (1)
		final size = native.encodeJpg(image, quality, bufferAddress);  // (2)
		if (size == 0) return null;
		final Pointer<Uint8> buffer = bufferAddress.value;  // (3)
		return OpenCVImage(pointer: buffer, length: size);
	}

	Future<bool> saveScreenshot(File file, {int quality = 75}) async {
		final OpenCVImage? jpg = getJpg(quality: quality);
		if (jpg == null) return false;
		await file.writeAsBytes(jpg.data, flush: true);
		jpg.dispose();
		return true;
	}
}

// To avoid copying data, we use a [Uint8List] that's backed by the native buffer.
// This means we cannot free it so long as the image is being used. So here we 
// hold onto the old frame and free it when we have a new frame.
class OpenCVImage {
	final Pointer<Uint8> pointer;
	final Uint8List data;
	final int length;
	OpenCVImage({required this.pointer, required this.length}) : data = pointer.asTypedList(length);

	void dispose() {
		native.freeImage(pointer);
	}
}
