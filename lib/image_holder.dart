
import 'package:image/image.dart' as imageLib;
import 'dart:typed_data';

class Imageholder{

  static final Imageholder _singleton = Imageholder._internal();

  factory Imageholder() {
    return _singleton;
  }

  Imageholder._internal();

   imageLib.Image cacheImage;
   Uint8List bytes;
}