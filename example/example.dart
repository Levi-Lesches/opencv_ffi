// ignore_for_file: avoid_print

import "dart:io";
import "package:opencv_ffi/opencv_ffi.dart";

const fpsDelay = Duration(milliseconds: 1000 ~/ 60);  // 60 FPS

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
      await Future<void>.delayed(fpsDelay);
    } on CameraReadException {
      print("Could not read camera");
      break;
    }
  }
  camera.dispose();
}
