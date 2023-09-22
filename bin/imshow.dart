// ignore_for_file: avoid_print

import "dart:io";
import "package:opencv_ffi/opencv_ffi.dart";

Camera getCamera(List<String> args) {
  if (args.isNotEmpty) {
    if (Platform.isWindows) {
      final index = int.tryParse(args.first);
      if (index == null) {
        print("Windows detected, device must be an index. Got: ${args.first}");
        exit(1);
      }
      return Camera.fromIndex(index);
    } else {
      return Camera.fromName(args.first);
    }
  } else {
    if (Platform.isWindows) {
      return Camera.fromIndex(0);
    } else {
      return Camera.fromName("/dev/video0");
    }
  }
}

void main(List<String> args) async {
  if (args.contains("-h") || args.contains("--help")) {
    print("Usage: dart run :imshow [device]");
    print("Args: ");
    print("- device: The index or name of your camera");
    print("  Defaults to 0 or /dev/video0");
    exit(0);
  }

  final Camera camera = getCamera(args);

  if (!camera.isOpened) {
    print("Could not open camera");
    exit(2);
  }

  try {
    while (true) {
      camera.showFrame();
    }
  } finally {
    camera.dispose();
  }
}
