import "dart:io";
import "package:opencv_ffi/opencv_ffi.dart";


void main() async {
  final camera =
      Platform.isWindows ? Camera.fromIndex(0) : Camera.fromName("/dev/video0");

  /// Note: getters will output -1 if the video device does not support a specific setting
  print(camera.zoom); 
  print(camera.fps);

  for (var i = 0; i < 3; i++){
    try {
      runtime(camera);
    } on CameraReadException {

      switch(i){
        case 0: 
          print('Check your device name');
        case 1:
        case 2:
          print('Camera disconnected, restarting');
          runtime(camera);
        case 3:
          print('Camera disconnected 3 times, exiting');
      }

    } finally {
      camera.dispose();
    }
  }
}

void runtime(Camera camera){
  while (true) {
    camera.showFrame();
  }
}

