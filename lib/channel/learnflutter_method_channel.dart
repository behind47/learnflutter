import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'learnflutter_platform_interface.dart';

/// An implementation of [LearnflutterPlatform] that uses method channels.
class MethodChannelLearnflutter extends LearnflutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('learnflutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
