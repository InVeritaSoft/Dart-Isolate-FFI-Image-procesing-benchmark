import 'dart:io';
import 'package:image/image.dart' as imageLib;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'case_four.dart';
import 'case_one.dart';
import 'case_three.dart';
import 'case_two.dart';
import 'ffi_one.dart';
import 'image_filter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File imageFile;
  imageLib.Image  image;
  String filename;
  List<int> _bytesOrigin;
  List<int> _bytesFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              if(_bytesOrigin != null)
               Flexible(child:  SizedBox(
                 height: 200,
                 child: Image.memory(
                   _bytesOrigin,
                   fit: BoxFit.contain,
                 ),
               )),
              if(_bytesOrigin != null)
                Flexible(child:  SizedBox(
                  height: 200,
                  child: Image.memory(
                    _bytesFilter,
                    fit: BoxFit.contain,
                  ),
                ))
            ],
          ),
          Spacer(),
          One(image: image,filename: filename,),
          Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'getImage',
        child: Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    filename = basename(imageFile.path);
    image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 300);
    _bytesOrigin = getPixels(image, filename);
    _bytesFilter = getFilterPixels(image, filename);
    setState(() {

    });
  }

}



