import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imageLib;
import '../image_filter.dart';

class Three extends StatefulWidget {

  final imageLib.Image image;
  final String filename;

  const Three({Key key, this.image, this.filename = ''}) : super(key: key);

  @override
  _ThreeState createState() => _ThreeState();
}

class _ThreeState extends State<Three> {
  var parsesPer10Second = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            child: Text('Run'),
            onPressed: () {
              _run();
            }),
        Text(
          '$parsesPer10Second',
        ),
      ],
    );
  }

  Future<void> _run() async {
    var lastFrameTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    var parses = 0;
    while (true) {
      await convertImage();
      parses++;
      final time = DateTime
          .now()
          .millisecondsSinceEpoch;
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

  /// Reused isolate

  static SendPort sendPort;

  static void isolateCallback(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((dynamic message) {
      final incomingMessage = message as ImageIsolateMessage;
      incomingMessage.sender.send(FilterApplayer().applyFilter(incomingMessage.map));
    });
  }

  static Future<void> init() async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      isolateCallback,
      receivePort.sendPort,
    );

    sendPort = await receivePort.first;
  }

  Future<void> convertImage() async {
    if (sendPort == null) {
      await init();
    }

    final receivePort = ReceivePort();

    sendPort.send(ImageIsolateMessage(receivePort.sendPort, <String, dynamic>{
      "image": widget.image,
      "filename": widget.filename,
    }));

    await receivePort.first;
  }
}

class ImageIsolateMessage {
  final SendPort sender;
  final Map<String, dynamic> map;

  ImageIsolateMessage(this.sender, this.map);
}
