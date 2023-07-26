import "package:opencv_ffi/opencv_ffi.dart";

void main(List<String> args) async {
  final cameraName = args.isEmpty ? "0" : args.first;
  final cameraIndex = int.tryParse(cameraName);
  final camera = cameraIndex == null ? Camera.fromName(cameraName) : Camera.fromIndex(cameraIndex);
  if (!camera.isOpened) {
    print("Could not open camera $cameraName");  // ignore: avoid_print
    return;
  }
  try {
    while (true) {
      camera.showFrame();
    }
  } finally {
    camera.dispose();    
  }
}
