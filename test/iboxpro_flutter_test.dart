import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iboxpro_flutter/iboxpro_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('iboxpro_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await IboxproFlutter.platformVersion, '42');
  });
}
