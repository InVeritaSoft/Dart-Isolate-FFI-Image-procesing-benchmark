import 'dart:io';

import 'package:demo_2_images/benchmark_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
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
      home: ImageFilterPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ImageFilterPage extends StatefulWidget {
  final String title;

  const ImageFilterPage({Key key, this.title}) : super(key: key);

  @override
  _ImageFilterPageState createState() => _ImageFilterPageState();
}

class _ImageFilterPageState extends State<ImageFilterPage> {

  File imageFile;
  imageLib.Image image;
  String filename;
  List<int> _bytesOrigin;
  List<int> _bytesFilter;

  ImageQuality selectedQuality;
  Algorithm selectedAlgorithm;
  ExecutionContext selectedExecutionContext;
  ProgramingOption selectedProgramingOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: image != null ? 200 : 0.0,
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
          _buildQualityDropDown(),
          _buildAlgorithmDropDown(),
          _buildExecutionContextDropDown(),
          _buildProgramingOptionDropDown(),
          Visibility(
            visible: (selectedQuality != null)
                && (selectedAlgorithm != null)
                && (selectedExecutionContext != null)
                && (selectedProgramingOption != null),
            child: BenchmarkWidget(filename: filename,image: image,),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'getImage',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    filename = basename(imageFile.path);
    image = imageLib.decodeImage(imageFile.readAsBytesSync());
    //image = imageLib.copyResize(image, width: 300);
    _bytesOrigin = getPixels(image, filename);
    _bytesFilter = getFilterPixels(image, filename);
    setState(() {});
  }

  Widget _buildAlgorithmDropDown(){
    return Container(
      height: 50,
      padding: EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<Algorithm>(
            isExpanded: true,
            hint:  Text("Select algorithm"),
            value: selectedAlgorithm,
            onChanged: (Algorithm value) {
              setState(() {
                selectedAlgorithm = value;
              });
            },
            items: <Algorithm>[...Algorithm.values].map((Algorithm algorithm) {
              return  DropdownMenuItem<Algorithm>(
                value: algorithm,
                child: Text(
                  algorithmToSting(algorithm),
                  style:  TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildQualityDropDown(){
    return Container(
      height: 50,
      padding: EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<ImageQuality>(
            isExpanded: true,
            hint:  Text("Select image quality"),
            value: selectedQuality,
            onChanged: (ImageQuality value) {
              setState(() {
                selectedQuality = value;
              });
            },
            items: <ImageQuality>[...ImageQuality.values].map((ImageQuality quality) {
              return  DropdownMenuItem<ImageQuality>(
                value: quality,
                child: Text(
                  imageQualityToSting(quality),
                  style:  TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildExecutionContextDropDown(){
    return Container(
      height: 50,
      padding: EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<ExecutionContext>(
            isExpanded: true,
            hint:  Text("Select execution context"),
            value: selectedExecutionContext,
            onChanged: (ExecutionContext value) {
              setState(() {
                selectedExecutionContext = value;
              });
            },
            items: <ExecutionContext>[...ExecutionContext.values].map((ExecutionContext executionContext) {
              return  DropdownMenuItem<ExecutionContext>(
                value: executionContext,
                child: Text(
                  executionContextToSting(executionContext),
                  style:  TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildProgramingOptionDropDown(){
    return Container(
      height: 50,
      padding: EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<ProgramingOption>(
            isExpanded: true,
            hint:  Text("Select programing option"),
            value: selectedProgramingOption,
            onChanged: (ProgramingOption value) {
              setState(() {
                selectedProgramingOption = value;
              });
            },
            items: <ProgramingOption>[...ProgramingOption.values].map((ProgramingOption programingOption) {
              return  DropdownMenuItem<ProgramingOption>(
                value: programingOption,
                child: Text(
                  programingOptionToSting(programingOption),
                  style:  TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  imageQualityToSting(ImageQuality imageQuality){
    switch(imageQuality) {
      case ImageQuality.fifty_percent: return '50 %';
      break;
      case ImageQuality.teen_percent: return '10 %';
      break;
      case ImageQuality.hundred_percent: return '100 %';
      break;
    }
  }

  executionContextToSting(ExecutionContext executionContext){
    switch(executionContext) {
      case ExecutionContext.mainThread: return 'Main thread';
      break;
      case ExecutionContext.oneIsolate: return 'One isolate';
      break;
      case ExecutionContext.reusedIsolate: return 'Reused isolate';
      break;
      case ExecutionContext.reusedMultiIsolates: return 'Reused multi-isolates';
      break;
    }
  }

  algorithmToSting(Algorithm algorithm){
    switch(algorithm) {
      case Algorithm.laplacian_edge_detection: return 'Laplacian Edge Detection';
      break;
    }
  }

  programingOptionToSting(ProgramingOption programingOption){
    switch(programingOption) {
      case ProgramingOption.pure_dart: return 'Pure Dart';
      break;
      case ProgramingOption.FFI: return 'FFI';
      break;
      case ProgramingOption.GPU: return 'GPU';
      break;
    }
  }

}

enum ImageQuality{
  teen_percent,
  fifty_percent,
  hundred_percent
}

enum Algorithm{
  laplacian_edge_detection
}

enum ExecutionContext{
  mainThread,
  oneIsolate,
  reusedIsolate,
  reusedMultiIsolates
}

enum  ProgramingOption{
  pure_dart,
  FFI,
  GPU,
}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  File imageFile;
//  imageLib.Image image;
//  String filename;
//  List<int> _bytesOrigin;
//  List<int> _bytesFilter;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            children: [
//              if (_bytesOrigin != null)
//                Flexible(
//                    child: SizedBox(
//                  height: 200,
//                  child: Image.memory(
//                    _bytesOrigin,
//                    fit: BoxFit.contain,
//                  ),
//                )),
//              if (_bytesOrigin != null)
//                Flexible(
//                    child: SizedBox(
//                  height: 200,
//                  child: Image.memory(
//                    _bytesFilter,
//                    fit: BoxFit.contain,
//                  ),
//                ))
//            ],
//          ),
//          Spacer(),
//          One(
//            image: image,
//            filename: filename,
//          ),
//          Spacer(),
//        ],
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: getImage,
//        tooltip: 'getImage',
//        child: Icon(Icons.camera_alt),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//
//  Future getImage() async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//    filename = basename(imageFile.path);
//    image = imageLib.decodeImage(imageFile.readAsBytesSync());
//    image = imageLib.copyResize(image, width: 300);
//    _bytesOrigin = getPixels(image, filename);
//    _bytesFilter = getFilterPixels(image, filename);
//    setState(() {});
//  }
//}
