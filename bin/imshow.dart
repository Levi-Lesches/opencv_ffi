import "package:opencv_ffi/opencv_ffi.dart";

void main() async {
  final camera = Camera(0);
  try {
    while (true) {
      if (!camera.read()) { throw Exception("Camera read failed"); }
      camera.display();
      await Future<void>.delayed(Duration(milliseconds: (1000/60).round()));
    }
  } finally {
    camera.dispose();    
  }
}
