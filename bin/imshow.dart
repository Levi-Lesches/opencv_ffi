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
