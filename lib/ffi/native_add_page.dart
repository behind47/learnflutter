import 'dart:ffi';

import 'package:flutter/material.dart';

class NativeAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NativeAddPageState();
}

class NativeAddPageState extends State<NativeAddPage> {

  late final DynamicLibrary nativeAddLib;

  late final int Function(int x, int y) nativeAdd;

  @override
  void initState() {
    nativeAddLib = DynamicLibrary.process();
    nativeAdd = nativeAddLib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add').asFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('使用ffi native add')),
      body: Container(
        child: Text('1+2=${nativeAdd(1,2)}'),
      ),
    );
  }

}