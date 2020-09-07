
import 'dart:typed_data';

import 'package:image/image.dart' as imageLib;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'image_filter.dart';

class PreviewImageScreen extends StatelessWidget {



  final imageLib.Image image;
  final String filename;

  Uint8List _bytesOrigin;
  Uint8List _bytesFilter;

  PreviewImageScreen(this.image,this.filename,{Key key}) :
        _bytesOrigin = getPixels(image, filename),
        _bytesFilter = getFilterPixels(image, filename),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview"),
      ),
      body:  Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_bytesOrigin != null)
              Expanded(
                  child: Image.memory(
                    _bytesOrigin,
                    fit: BoxFit.contain,
                  )),
            if (_bytesOrigin != null)
              Expanded(
                  child: Image.memory(
                    _bytesFilter,
                    fit: BoxFit.contain,
                  ))
          ],
        ),
      ),
    );
  }
}
