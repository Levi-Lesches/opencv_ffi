import "package:opencv_ffi/opencv_ffi.dart";

void main() async {
  final camera = Camera(0);
  try {
    while (true) {
      if (!camera.read()) { throw Exception("Camera read failed"); }
      camera.display();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  } finally {
    camera.dispose();    
  }
}
