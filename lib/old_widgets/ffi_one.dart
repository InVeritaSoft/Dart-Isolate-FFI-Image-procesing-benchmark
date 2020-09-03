import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imageLib;
import 'package:images_filter/images_filter.dart';

class FFIWidget extends StatefulWidget {

  final imageLib.Image  image;
  final String filename;

  const FFIWidget({Key key, this.image, this.filename}) : super(key: key);

  @override
  _FFIWidgetState createState() => _FFIWidgetState();
}

class _FFIWidgetState extends State<FFIWidget> {

  String status = 'Start';
  var parsesPer10Second = 0;
  List<int> resultBytes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(status),
        RaisedButton(onPressed: (){
          applyAndSetFilter();
        }),
        RaisedButton(
            child: Text('Run'),
            onPressed: () {
              _run();
            }),
        Text(
          '$parsesPer10Second',
        ),
        if(resultBytes!=null)
        SizedBox(
          height: 200,
          child: Image.memory(
            resultBytes,
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }

  Future<void> _run() async {
    var lastFrameTime = DateTime.now().millisecondsSinceEpoch;
    var parses = 0;
    while (true) {
      convertImage();
      parses++;
      final time = DateTime.now().millisecondsSinceEpoch;
      if ((time - lastFrameTime) > (10000 + 1)) {
        print(parses);
        setState(() {
          parsesPer10Second = parses;
        });
        parses = 0;
        lastFrameTime = time;
        await Future.delayed(Duration(milliseconds: 1));
      }
    }
  }

  void convertImage() {
    List<num> weights = [0, 1, 0, 1, -4, 1, 0, 1, 0];
    num bias = 0.0;
    Pointer<Int8> _weights =  allocate(count: weights.length);
    for(int i = 0; i < weights.length; i++){
      _weights[i] = weights[i];
    }
    List<int> _bytes = widget.image.getBytes();
    Pointer<Uint8> _data =  allocate(count: _bytes.length);
    for(int i = 0; i < _bytes.length; i++){
      _data[i] = _bytes[i];
    }
    var result = ImagesFilter().applyImageFilter(
        _data,
        _bytes.length,
        widget.image.width,
        widget.image.height,
        _weights,
        weights.length,
        bias);
    result.asTypedList(_bytes.length);
    free(_data);
    free(_weights);
  }




  void applyAndSetFilter(){
    List<num> weights = [0, 1, 0, 1, -4, 1, 0, 1, 0];
    num bias = 0.0;
    Pointer<Int8> _weights =  allocate(count: weights.length);
    for(int i = 0; i < weights.length; i++){
      _weights[i] = weights[i];
    }
    List<int> _bytes = widget.image.getBytes();
    Pointer<Uint8> _data =  allocate(count: _bytes.length);
    for(int i = 0; i < _bytes.length; i++){
      _data[i] = _bytes[i];
    }
    var result = ImagesFilter().applyImageFilter(
        _data,
        _bytes.length,
        widget.image.width,
        widget.image.height,
        _weights,
        weights.length,
        bias);
    var list = result.asTypedList(_bytes.length);
    var resultImage = imageLib.Image.fromBytes(
        widget.image.width,
        widget.image.height,
        list);
    resultBytes = imageLib.encodeNamedImage(resultImage, widget.filename);
    free(_data);
    free(_weights);

    status = 'Done';
    setState(() {

    });
  }
}
