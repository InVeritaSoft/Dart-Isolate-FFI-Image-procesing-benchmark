import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imageLib;
import '../image_filter.dart';

class One extends StatefulWidget {

  final imageLib.Image  image;
  final String filename;

  const One({Key key, this.image, this.filename  = ''}) : super(key: key);

  @override
  _OneState createState() => _OneState();
}

class _OneState extends State<One> {
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

  /// Main thread
  void convertImage() {
    applyFilter(<String, dynamic>{
      "image": widget.image,
      "filename": widget.filename,
    });
  }
}
