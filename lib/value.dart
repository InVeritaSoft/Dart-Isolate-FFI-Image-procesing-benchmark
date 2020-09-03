import 'commands.dart';

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

Map<ExecutionContext,ExecutionContextCommand> executionContextMap = {
  ExecutionContext.mainThread: MainThreadCommand(),
  ExecutionContext.oneIsolate: OneIsolateCommand(),
  ExecutionContext.reusedIsolate: ReusedIsolateCommand(),
  ExecutionContext.reusedMultiIsolates: ReusedMultiIsolatesCommand(),
};

enum  ProgramingOption{
  pure_dart,
  FFI,
  GPU,
}