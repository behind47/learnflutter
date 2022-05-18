import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnflutter/learnflutter.dart';

class NativeAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NativeAddPageState();
}

class NativeAddPageState extends State<NativeAddPage> {
  String _platformVersion = 'Unknown';
  final _learnflutterPlugin = Learnflutter();
  late final DynamicLibrary nativeAddLib;
  late final int Function(int x, int y) nativeAdd;

  @override
  void initState() {
    super.initState();
    nativeAddLib = DynamicLibrary.process();
    nativeAdd = nativeAddLib
        .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add')
        .asFunction();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _learnflutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
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
          ],
        ),
      ),
    );
  }
}
