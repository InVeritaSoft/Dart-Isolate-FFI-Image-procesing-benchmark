import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:demo_2_images/value.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imageLib;

import 'image_filter.dart';

abstract class ExecutionContextCommand{

  imageLib.Image  image;
  String filename;
  ProgramingOption programingOption = ProgramingOption.pure_dart;

  Future execute();
}

class MainThreadCommand extends ExecutionContextCommand{

  MainThreadCommand();

  Future execute() async{
    FilterApplayer().applyFilter(<String, dynamic>{
      "image": image,
      "filename": filename,
      "programingOption": programingOption
    });
  }
}


class OneIsolateCommand extends ExecutionContextCommand{

  OneIsolateCommand();

  Future execute() async{
    await compute(FilterApplayer().applyFilter,  <String,dynamic>{
      "image": image,
      "filename": filename,
      "programingOption": programingOption
    });
  }
}

class ReusedIsolateCommand extends ExecutionContextCommand{

  static SendPort sendPort;

  ReusedIsolateCommand();

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

  Future execute() async{
    if (sendPort == null) {
      await init();
    }
    final receivePort = ReceivePort();
    sendPort.send(ImageIsolateMessage(receivePort.sendPort, <String, dynamic>{
      "image": image,
      "filename": filename,
      "programingOption": programingOption
    }));
    await receivePort.first;
  }
}

class ReusedMultiIsolatesCommand extends ExecutionContextCommand{

  ReusedMultiIsolatesCommand();

  static List<SendPort> availableSendPorts;
  static final sendPortStream = StreamController<void>.broadcast();

  static Future<SendPort> intialize() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      isolateCallback,
      receivePort.sendPort,
    );
    return await receivePort.first;
  }

  static void isolateCallback(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((dynamic message) {
      final incomingMessage = message as ImageIsolateMessage;
      incomingMessage.sender.send(FilterApplayer().applyFilter(incomingMessage.map));
    });
  }

  static Future<void> init() async {
    availableSendPorts = await Future.wait([
      intialize(),
      intialize(),
      intialize(),
      intialize(),
      intialize(),
      intialize(),
      intialize(),
      intialize(),
    ]);
  }

  Future<void> execute() async {
    if (availableSendPorts == null) {
      await init();
    }
    // Wait until one is available
    if (availableSendPorts.isEmpty) {
      await sendPortStream.stream.first;
    }
    final sendPort = availableSendPorts.removeAt(0);
    final receivePort = ReceivePort();
    sendPort.send(ImageIsolateMessage(receivePort.sendPort, <String, dynamic>{
      "image": image,
      "filename": filename,
      "programingOption": programingOption
    }));
    receivePort.first.then((value){
      availableSendPorts.add(sendPort);
      sendPortStream.add(null);
    });

  }
}

class ImageIsolateMessage {

  final SendPort sender;
  final Map<String, dynamic> map;

  ImageIsolateMessage(this.sender, this.map);
}