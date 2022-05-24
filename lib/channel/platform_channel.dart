import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnflutter/channel/learnflutter_method_channel.dart';
import 'package:learnflutter/channel/learnflutter_platform_interface.dart';

class PlatformChannel {
  static final String platformChannelName = 'platform';
  MethodChannel _platform;

  factory PlatformChannel(String name) => PlatformChannel._internal(name);

  PlatformChannel._internal(String name) : _platform = MethodChannel(name);

  Future<String> getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level: "${e.message}".';
    }
    return batteryLevel;
  }

  Future<String?> getPlatformVersion() {
    return LearnflutterPlatform.instance.getPlatformVersion();
  }
}