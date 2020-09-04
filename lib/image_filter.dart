import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:demo_2_images/value.dart';
import 'package:ffi/ffi.dart';
import 'package:image/image.dart' as imageLib;
import 'package:images_filter/images_filter.dart';
//import 'package:native_filters/native_filters.dart';

final List<num> weights = [0, 1, 0, 1, -4, 1, 0, 1, 0];
final num bias = 0.0;

Uint8List getPixels(image, filename) {
  Uint8List _bytes = image.getBytes();
  imageLib.Image _image = imageLib.Image.fromBytes(
      image.width,
      image.height,
      _bytes,
  );
  _bytes = imageLib.encodeNamedImage(_image, filename);
  return _bytes;
}

Uint8List getFilterPixels(image, filename) {
  Uint8List _bytes = image.getBytes();
  _apply(_bytes, image.width, image.height,weights,bias);
  imageLib.Image _image =
  imageLib.Image.fromBytes(
      image.width,
      image.height,
      _bytes,
  );
  _bytes = imageLib.encodeNamedImage(_image, filename);
  return _bytes;
}

void _apply(Uint8List pixels, int width, int height,weights,bias) =>
    convolute(
        pixels,
        width,
        height,
        _normalizeKernel(weights),
        bias
    );

int clampPixel(int x) => x.clamp(0, 255);

// Convolute - weights are 3x3 matrix
void convolute(
    Uint8List pixels, int width, int height, List<num> weights, num bias) {
  var bytes = Uint8List.fromList(pixels);
  //var bytes = pixels;
  int side = sqrt(weights.length).round();
  int halfSide = ~~(side / 2).round() - side % 2;
  int sw = width;
  int sh = height;

  int w = sw;
  int h = sh;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      int sy = y;
      int sx = x;
      int dstOff = (y * w + x) * 4;
      num r = bias, g = bias, b = bias;
      for (int cy = 0; cy < side; cy++) {
        for (int cx = 0; cx < side; cx++) {
          int scy = sy + cy - halfSide;
          int scx = sx + cx - halfSide;

          if (scy >= 0 && scy < sh && scx >= 0 && scx < sw) {
            int srcOff = (scy * sw + scx) * 4;
            num wt = weights[cy * side + cx];

            r += bytes[srcOff] * wt;
            g += bytes[srcOff + 1] * wt;
            b += bytes[srcOff + 2] * wt;
          }
        }
      }
      pixels[dstOff] = clampPixel(r.round());
      pixels[dstOff + 1] = clampPixel(g.round());
      pixels[dstOff + 2] = clampPixel(b.round());
    }
  }
}

List<num> _normalizeKernel(List<num> kernel) {
  num sum = 0;
  for (var i = 0; i < kernel.length; i++) {
    sum += kernel[i];
  }
  if (sum != 0 && sum != 1) {
    for (var i = 0; i < kernel.length; i++) {
      kernel[i] /= sum;
    }
  }
  return kernel;
}



class FilterApplayer{

//  final _filtersFactory = const FilterFactory();
//  Filter _filter;

  static final FilterApplayer _singleton = FilterApplayer._internal();

  factory FilterApplayer() {
    return _singleton;
  }

  FilterApplayer._internal();

//  init() async{
//    _filter = await _filtersFactory.create('GPUImageLaplacianFilter');
//  }

  imageLib.Image cacheImage;
  Uint8List _bytes;

  List<int> applyFilter(Map<String, dynamic> params) {
    ProgramingOption programingOption = params['programingOption'];
    imageLib.Image image = params["image"];
    if(image.width != cacheImage?.width){
      print('Caching images');
      cacheImage = image;
      _bytes = image.getBytes();
    }

    if (programingOption == ProgramingOption.pure_dart) {
      _apply(_bytes, image.width, image.height, weights, bias);
      return _bytes;
    }

    if (programingOption == ProgramingOption.FFI) {
      Pointer<Int8> _weights = allocate(count: weights.length);
      for (int i = 0; i < weights.length; i++) {
        _weights[i] = weights[i];
      }
      Pointer<Uint8> _data = allocate(count: _bytes.length);
      for (int i = 0; i < _bytes.length; i++) {
        _data[i] = _bytes[i];
      }
      var result = ImagesFilter().applyImageFilter(
          _data,
          _bytes.length,
          image.width,
          image.height,
          _weights,
          weights.length,
          bias);
      result.asTypedList(_bytes.length);
      free(_data);
      free(_weights);
      return result.asTypedList(_bytes.length,);
    }
    if (programingOption == ProgramingOption.GPU) {


    }
  }
}


