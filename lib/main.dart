import 'package:demo/EntryList.dart';
import 'package:demo/MyApp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'materialApp',
    home: IndexPage(),
  ));
}

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("indexPage"),
      ),
      body: Center(
        child: EntryList(),
      ),
    );
  }
}
