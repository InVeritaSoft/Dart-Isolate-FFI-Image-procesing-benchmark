
import 'package:demo_2_images/benchmark_widget.dart';
import 'package:demo_2_images/preview_screen.dart';
import 'package:demo_2_images/value.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


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


  imageLib.Image image;
  String filename;

  ImageQuality selectedQuality;
  Algorithm selectedAlgorithm;
  ExecutionContext selectedExecutionContext;
  ProgramingOption selectedProgramingOption;
  int selectIsolatesPoolSize = 8;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Column(
        mainAxisSize: MainAxisSize.max,
        children: [
         if (filename != null)
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Center(child: Text('File  : $filename')),
           ),
          if (filename != null)RaisedButton(
            child: Text('Image Preview'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreviewImageScreen(
                    image,filename
                )
                ),
              );
            }),
          _buildQualityDropDown(),
          _buildAlgorithmDropDown(),
          _buildExecutionContextDropDown(),
          if(selectedExecutionContext == ExecutionContext.reusedMultiIsolates)
            _buildCountIsolatesDropDown(),
          _buildProgramingOptionDropDown(),

      
          if ((selectedQuality != null)
                && (selectedAlgorithm != null)
                && (selectedExecutionContext != null)
                && (selectedProgramingOption != null)
                && (image != null)
          )
             BenchmarkWidget(
               command: executionContextMap[selectedExecutionContext]
                 ..filename = filename
                 ..image = imageLib.copyResize(
                          image,
                          width: (image.width * calculateImageQuality(selectedQuality)).ceil(),
                          height: (image.height * calculateImageQuality(selectedQuality)).ceil()
                 )
                 ..programingOption = selectedProgramingOption,
             ),
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
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    filename = basename(imageFile.path);
    image = imageLib.decodeImage(imageFile.readAsBytesSync());
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

  Widget _buildCountIsolatesDropDown(){
    return Container(
      height: 50,
      padding: EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<int>(
            isExpanded: true,
            hint:  Text("Select pool size"),
            value: selectIsolatesPoolSize,
            onChanged: (int value) {
              setState(() {
                selectIsolatesPoolSize = value;
              });
            },
            items: List<int>.generate(10, (i) => i + 1).map((int value) {
              return  DropdownMenuItem<int>(
                value: value,
                child: Text(
                  '$value isolates',
                  style:  TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  calculateImageQuality(ImageQuality imageQuality){
    switch(imageQuality) {
      case ImageQuality.fifty_percent: return 0.5;
      break;
      case ImageQuality.teen_percent: return 0.1;
      break;
      case ImageQuality.hundred_percent: return 1.0;
      break;
    }
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
      case ProgramingOption.GPU: return 'GPU (don\'t implements )';
      break;
    }
  }

}
