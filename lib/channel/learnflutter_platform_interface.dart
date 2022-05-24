import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'learnflutter_method_channel.dart';

abstract class LearnflutterPlatform extends PlatformInterface {
  /// Constructs a LearnflutterPlatform.
  LearnflutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static LearnflutterPlatform _instance = MethodChannelLearnflutter();

  /// The default instance of [LearnflutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelLearnflutter].
  static LearnflutterPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LearnflutterPlatform] when
  /// they register themselves.
  static set instance(LearnflutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
