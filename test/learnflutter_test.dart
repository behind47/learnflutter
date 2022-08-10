import 'package:flutter_test/flutter_test.dart';
import 'package:learnflutter/channel/platform_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLearnflutterPlatform 
    with MockPlatformInterfaceMixin {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  test('getPlatformVersion', () async {
    PlatformChannel learnflutterPlugin = PlatformChannel();
  
    expect(await learnflutterPlugin.getPlatformVersion(), '42');
  });
}
