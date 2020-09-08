

import 'package:demo_2_images/value.dart';

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