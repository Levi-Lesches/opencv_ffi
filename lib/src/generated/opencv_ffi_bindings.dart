// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as pkg_ffi;

/// Bindings for `src/opencv_ffi.h`.
///
/// Regenerate bindings with `dart run ffigen --config ffigen.yaml -v severe`.
///
class OpenCVBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  OpenCVBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  OpenCVBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// VideoCapture code
  ffi.Pointer<VideoCapture> VideoCapture_getByIndex(
    int index,
  ) {
    return _VideoCapture_getByIndex(
      index,
    );
  }

  late final _VideoCapture_getByIndexPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<VideoCapture> Function(ffi.Int)>>(
          'VideoCapture_getByIndex');
  late final _VideoCapture_getByIndex = _VideoCapture_getByIndexPtr.asFunction<
      ffi.Pointer<VideoCapture> Function(int)>();

  ffi.Pointer<VideoCapture> VideoCapture_getByName(
    ffi.Pointer<pkg_ffi.Utf8> name,
  ) {
    return _VideoCapture_getByName(
      name,
    );
  }

  late final _VideoCapture_getByNamePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<VideoCapture> Function(
              ffi.Pointer<pkg_ffi.Utf8>)>>('VideoCapture_getByName');
  late final _VideoCapture_getByName = _VideoCapture_getByNamePtr.asFunction<
      ffi.Pointer<VideoCapture> Function(ffi.Pointer<pkg_ffi.Utf8>)>();

  void VideoCapture_destroy(
    ffi.Pointer<VideoCapture> capture,
  ) {
    return _VideoCapture_destroy(
      capture,
    );
  }

  late final _VideoCapture_destroyPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<VideoCapture>)>>(
          'VideoCapture_destroy');
  late final _VideoCapture_destroy = _VideoCapture_destroyPtr.asFunction<
      void Function(ffi.Pointer<VideoCapture>)>();

  void VideoCapture_release(
    ffi.Pointer<VideoCapture> capture,
  ) {
    return _VideoCapture_release(
      capture,
    );
  }

  late final _VideoCapture_releasePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<VideoCapture>)>>(
          'VideoCapture_release');
  late final _VideoCapture_release = _VideoCapture_releasePtr.asFunction<
      void Function(ffi.Pointer<VideoCapture>)>();

  int VideoCapture_isOpened(
    ffi.Pointer<VideoCapture> capture,
  ) {
    return _VideoCapture_isOpened(
      capture,
    );
  }

  late final _VideoCapture_isOpenedPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<VideoCapture>)>>(
          'VideoCapture_isOpened');
  late final _VideoCapture_isOpened = _VideoCapture_isOpenedPtr.asFunction<
      int Function(ffi.Pointer<VideoCapture>)>();

  int VideoCapture_read(
    ffi.Pointer<VideoCapture> capture,
    ffi.Pointer<Mat> image,
  ) {
    return _VideoCapture_read(
      capture,
      image,
    );
  }

  late final _VideoCapture_readPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<VideoCapture>,
              ffi.Pointer<Mat>)>>('VideoCapture_read');
  late final _VideoCapture_read = _VideoCapture_readPtr.asFunction<
      int Function(ffi.Pointer<VideoCapture>, ffi.Pointer<Mat>)>();

  void VideoCapture_setProperty(
    ffi.Pointer<VideoCapture> capture,
    int propertyID,
    int value,
  ) {
    return _VideoCapture_setProperty(
      capture,
      propertyID,
      value,
    );
  }

  late final _VideoCapture_setPropertyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<VideoCapture>, ffi.Int,
              ffi.Int)>>('VideoCapture_setProperty');
  late final _VideoCapture_setProperty = _VideoCapture_setPropertyPtr
      .asFunction<void Function(ffi.Pointer<VideoCapture>, int, int)>();

  int VideoCapture_getProperty(
    ffi.Pointer<VideoCapture> capture,
    int propertyID,
  ) {
    return _VideoCapture_getProperty(
      capture,
      propertyID,
    );
  }

  late final _VideoCapture_getPropertyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<VideoCapture>, ffi.Int)>>('VideoCapture_getProperty');
  late final _VideoCapture_getProperty = _VideoCapture_getPropertyPtr
      .asFunction<int Function(ffi.Pointer<VideoCapture>, int)>();

  /// Matrix code
  ffi.Pointer<Mat> Mat_create() {
    return _Mat_create();
  }

  late final _Mat_createPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<Mat> Function()>>('Mat_create');
  late final _Mat_create =
      _Mat_createPtr.asFunction<ffi.Pointer<Mat> Function()>();

  void Mat_destroy(
    ffi.Pointer<Mat> matrix,
  ) {
    return _Mat_destroy(
      matrix,
    );
  }

  late final _Mat_destroyPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<Mat>)>>(
          'Mat_destroy');
  late final _Mat_destroy =
      _Mat_destroyPtr.asFunction<void Function(ffi.Pointer<Mat>)>();

  /// Misc code
  void imshow(
    ffi.Pointer<Mat> image,
  ) {
    return _imshow(
      image,
    );
  }

  late final _imshowPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<Mat>)>>(
          'imshow');
  late final _imshow = _imshowPtr.asFunction<void Function(ffi.Pointer<Mat>)>();

  int encodeJpg(
    ffi.Pointer<Mat> image,
    int quality,
    ffi.Pointer<ffi.Pointer<ffi.Uint8>> pointer,
  ) {
    return _encodeJpg(
      image,
      quality,
      pointer,
    );
  }

  late final _encodeJpgPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<Mat>, ffi.Int,
              ffi.Pointer<ffi.Pointer<ffi.Uint8>>)>>('encodeJpg');
  late final _encodeJpg = _encodeJpgPtr.asFunction<
      int Function(
          ffi.Pointer<Mat>, int, ffi.Pointer<ffi.Pointer<ffi.Uint8>>)>();

  void setLogLevel(
    int level,
  ) {
    return _setLogLevel(
      level,
    );
  }

  late final _setLogLevelPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int)>>('setLogLevel');
  late final _setLogLevel = _setLogLevelPtr.asFunction<void Function(int)>();

  void freeImage(
    ffi.Pointer<ffi.Uint8> pointer,
  ) {
    return _freeImage(
      pointer,
    );
  }

  late final _freeImagePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Uint8>)>>(
          'freeImage');
  late final _freeImage =
      _freeImagePtr.asFunction<void Function(ffi.Pointer<ffi.Uint8>)>();
}

final class VideoCapture extends ffi.Opaque {}

final class Mat extends ffi.Opaque {}
