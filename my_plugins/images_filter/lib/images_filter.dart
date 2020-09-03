// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX

final DynamicLibrary nativeImageFilterLib = Platform.isAndroid
    ? DynamicLibrary.open("libimages_filter.so")
    : DynamicLibrary.process();

class ImagesFilter {

  final int Function(int x, int y) nativeAdd =
    nativeImageFilterLib
      .lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add")
      .asFunction();

  Pointer<Int32> getArray(
      Pointer<Int32> arr,
      ) {
    _getArray ??=
        nativeImageFilterLib.lookupFunction<_c_getArray, _dart_getArray>('getArray');
    return _getArray(
      arr,
    );
  }

  _dart_getArray _getArray;


  Pointer<Uint8> applyImageFilter(
      Pointer<Uint8> pixels,
      int pixels_lenght,
      int width,
      int height,
      Pointer<Int8> weights,
      int weights_lenght,
      double bias,
      ) {
    _applyImageFilter ??=
        nativeImageFilterLib.lookupFunction<_c_applyImageFilter, _dart_applyImageFilter>(
            'applyImageFilter');
    return _applyImageFilter(
      pixels,
      pixels_lenght,
      width,
      height,
      weights,
      weights_lenght,
      bias,
    );
  }

  _dart_applyImageFilter _applyImageFilter;


}

typedef _c_getArray = Pointer<Int32> Function(
    Pointer<Int32> arr,
    );

typedef _dart_getArray = Pointer<Int32> Function(
    Pointer<Int32> arr,
    );

typedef _c_applyImageFilter = Pointer<Uint8> Function(
    Pointer<Uint8> pixels,
    Int32 pixels_lenght,
    Int32 width,
    Int32 height,
    Pointer<Int8> weights,
    Int32 weights_lenght,
    Float bias,
    );

typedef _dart_applyImageFilter = Pointer<Uint8> Function(
    Pointer<Uint8> pixels,
    int pixels_lenght,
    int width,
    int height,
    Pointer<Int8> weights,
    int weights_lenght,
    double bias,
    );

