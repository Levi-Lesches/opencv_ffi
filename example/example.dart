import "dart:io";
import "package:opencv_ffi/opencv_ffi.dart";

void main() async {
  final camera =
      Platform.isWindows ? Camera.fromIndex(0) : Camera.fromName("/dev/video0");
  camera.zoom(0);
  try {
    runtime(Camera camera);
  } on CameraReadException {
    runtime(Camera camera);
  } finally {
    camera.dispose();
  }
}

void runtime(camera){
  while (true) {
    camera.showFrame();
  }
}
