import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imageLib;
import '../image_filter.dart';

class Two extends StatefulWidget {

  final imageLib.Image  image;
  final String filename;

  const Two({Key key, this.image, this.filename  = ''}) : super(key: key);

  @override
  _TwoState createState() => _TwoState();
}

class _TwoState extends State<Two> {
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
      await convertImage();
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

  /// Isolate
  Future<void> convertImage() async {
    await compute(FilterApplayer().applyFilter,  <String,dynamic>{
      "image": widget.image,
      "filename": widget.filename,
    });
  }
}
