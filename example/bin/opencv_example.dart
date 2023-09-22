import "dart:io";
import "package:opencv_ffi/opencv_ffi.dart";

void main() async {
  final camera = Platform.isWindows ? Camera.fromIndex(0) : Camera.fromName("/dev/video0");
  try {
    while (true) {
      camera.showFrame();
    }
  } finally {
    camera.dispose();    
  }
}