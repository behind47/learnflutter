import 'package:flutter_test/flutter_test.dart';
import 'package:learnflutter/channel/learnflutter_platform_interface.dart';
import 'package:learnflutter/channel/learnflutter_method_channel.dart';
import 'package:learnflutter/channel/platform_channel.dart';
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
    PlatformChannel learnflutterPlugin = PlatformChannel();
    MockLearnflutterPlatform fakePlatform = MockLearnflutterPlatform();
    LearnflutterPlatform.instance = fakePlatform;
  
    expect(await learnflutterPlugin.getPlatformVersion(), '42');
  });
}
