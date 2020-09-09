
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:demo_2_images/benchmark_widget.dart';
import 'package:demo_2_images/preview_screen.dart';
import 'package:demo_2_images/utils.dart';
import 'package:demo_2_images/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;
import 'commands.dart';

class ImageFilterScreen extends StatefulWidget {

  const ImageFilterScreen({Key key}) : super(key: key);

  @override
  _ImageFilterScreenState createState() => _ImageFilterScreenState();
}

class _ImageFilterScreenState extends State<ImageFilterScreen> {


  imageLib.Image image;
  String filename;

  ImageQuality selectedQuality;
  Algorithm selectedAlgorithm;
  ExecutionContext selectedExecutionContext;
  ProgramingOption selectedProgramingOption;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters screen"),
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


    if (Platform.isAndroid || Platform.isIOS) {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      filename = basename(imageFile.path);
      image = imageLib.decodeImage(imageFile.readAsBytesSync());
      setState(() {});
      return;
    }

    if(Platform.isMacOS || Platform.isLinux || Platform.isWindows){
      filename = 'assets/images/mona_lisa.jpg';
      ByteData monaLisaData = await rootBundle.load(filename);
      Uint8List monaLisaBytes = monaLisaData.buffer.asUint8List();
      image = imageLib.decodeImage(monaLisaBytes);
      setState(() {});
      return;
    }




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
            value: ReusedMultiIsolatesCommand.poolSize,
            onChanged: (int value) {
              setState(() {
                ReusedMultiIsolatesCommand.poolSize = value;
              });
            },
            items: List<int>.generate(20, (i) => i + 1).map((int value) {
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

}
