import "dart:async";
import "dart:developer";
import "dart:isolate";
import "dart:ffi";
import 'package:ffi/ffi.dart';
import "dart:typed_data";
import 'package:flutter/material.dart';
import 'package:images_filter/images_filter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('1 + 2 == ${ImagesFilter().nativeAdd(1, 2)}'),
              Text('${getArray()}'),
              Text('${apply()}'),
            ],
          ),
        ),
      ),
    );
  }

  getArray(){
    Pointer<Int32> _data =  allocate(count: 10);
    for(int i = 0; i < 10; i++){
      _data[i] = i;
    }
    var result = ImagesFilter().getArray(_data);
    free(_data);
    return result.asTypedList(10);
  }

  apply(){
     List<num> weights = [0, 1, 0, 1, -4, 1, 0, 1, 0];
     num bias = 0.0;
     Pointer<Int32> _weights =  allocate(count: weights.length);
     for(int i = 0; i < weights.length; i++){
       _weights[i] = weights[i];
     }
    Pointer<Int32> _data =  allocate(count: 1000);
    for(int i = 0; i < 1000; i++){
      _data[i] = 125;
    }
   ImagesFilter().applyImageFilter(
        _data,
        1000,
        100,
        100,
        _weights,
        weights.length,
        bias
    );
    //var value = _data.asTypedList(1000)[100];
    free(_data);
    free(_weights);
    return 0;
  }
}
