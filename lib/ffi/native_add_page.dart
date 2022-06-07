import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnflutter/channel/platform_channel.dart';

class NativeAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NativeAddPageState();
}

class NativeAddPageState extends State<NativeAddPage> {
  String _platformVersion = 'Unknown';
  late final DynamicLibrary nativeAddLib;
  late final int Function(int x, int y) nativeAdd;
  late final int Function() getTag;
  String _batteryLevel = '';

  @override
  void initState() {
    super.initState();
    nativeAddLib = DynamicLibrary.process();
    // nativeAdd = nativeAddLib
    //     .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add')
    //     .asFunction();
    nativeAdd = nativeAddLib.lookupFunction<Int32 Function(Int32, Int32), int Function(int, int)>('native_add');
    
    getTag = nativeAddLib
        .lookup<NativeFunction<Int32 Function()>>('native_getTag')
        .asFunction();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // var platformChannel1 =PlatformChannel(PlatformChannel.platformChannelName);
      // print('platformChannel1 : ${platformChannel1.hashCode}');
      platformVersion = await PlatformChannel.instance.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // var platformChannel2 = PlatformChannel(PlatformChannel.platformChannelName);
    // print('platformChannel2 : ${platformChannel2.hashCode}');
    String batteryLevel = await PlatformChannel.instance.getBatteryLevel();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            Text('1+1=${nativeAdd(1, 1)}'),
            Text('device batteryLevel: $_batteryLevel'),
            Text('native tag : ${getTag()}'),
            TextButton(
                onPressed: () {
                  // var platformChannel3 =PlatformChannel(PlatformChannel.platformChannelName);
                  // print('platformChannel3 : ${platformChannel3.hashCode}');
                  PlatformChannel.instance.test();
                },
                child: Text('click to test')),
          ],
        ),
      ),
    );
  }
}
