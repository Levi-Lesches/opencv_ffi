import "dart:io";
import "package:opencv_ffi/opencv_ffi.dart";

void main() async {
  final camera = Platform.isWindows 
    ? Camera.fromIndex(0) 
    : Camera.fromName("/dev/video0");

  if (!camera.isOpened) {
    print("Could not open camera");
    return;
  }
    
  while (true) {
    try {
      camera.showFrame();
      await Future<void>.delayed(Duration(milliseconds: 1000 ~/ 60));  // 60 FPS
    } on CameraReadException {
      print("Could not read camera");
      break;
    }
  }
  camera.dispose();
}
