import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:images_filter/images_filter.dart';

void main() {
  const MethodChannel channel = MethodChannel('images_filter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ImagesFilter.platformVersion, '42');
  });
}
