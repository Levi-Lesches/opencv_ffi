/// An exception thrown by OpenCV.
class OpenCVException implements Exception {}

/// An exception indicating the camera could not be read.
class CameraReadException extends OpenCVException {}

/// An exception indicating that an image could not be encoded.
class ImageEncodeException extends OpenCVException {}
