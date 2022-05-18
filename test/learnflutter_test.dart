import 'package:flutter_test/flutter_test.dart';
import 'package:learnflutter/learnflutter.dart';
import 'package:learnflutter/learnflutter_platform_interface.dart';
import 'package:learnflutter/learnflutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLearnflutterPlatform 
    with MockPlatformInterfaceMixin
    implements LearnflutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LearnflutterPlatform initialPlatform = LearnflutterPlatform.instance;

  test('$MethodChannelLearnflutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLearnflutter>());
  });

  test('getPlatformVersion', () async {
    Learnflutter learnflutterPlugin = Learnflutter();
    MockLearnflutterPlatform fakePlatform = MockLearnflutterPlatform();
    LearnflutterPlatform.instance = fakePlatform;
  
    expect(await learnflutterPlugin.getPlatformVersion(), '42');
  });
}
