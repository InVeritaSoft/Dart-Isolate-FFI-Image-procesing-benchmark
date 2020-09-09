import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'commands.dart';
import 'image_filter.dart';
import 'package:image/image.dart' as imageLib;

class BenchmarkWidget extends StatefulWidget {

  final ExecutionContextCommand command;

  const BenchmarkWidget({Key key, this.command}) :
      super(key: key);

  @override
  _BenchmarkWidgetState createState() => _BenchmarkWidgetState();
}

class _BenchmarkWidgetState extends State<BenchmarkWidget> {

  var applyFilterPer10Second = 0;
  bool isRunning = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            child: Text(!isRunning ? 'Start' : 'Stop'),
            onPressed: () {
              setState(() {
                isRunning = !isRunning;
                applyFilterPer10Second = 0;
                _run();
              });
            }),
        if (isRunning)
        Text(
          'Apply filter per 10 Seconds: $applyFilterPer10Second',
        ),
      ],
    );
  }

  Future<void> _run() async {
    var lastFrameTime = DateTime.now().millisecondsSinceEpoch;
    var parses = 0;
    while (isRunning) {

      await widget.command.execute();

      parses++;
      final time = DateTime.now().millisecondsSinceEpoch;
      if ((time - lastFrameTime) > (10000 + 1)) {
        print(parses);
        setState(() {
          applyFilterPer10Second = parses;
        });
        parses = 0;
        lastFrameTime = time;
        await Future.delayed(Duration(milliseconds: 1));
      }
    }
  }

}


