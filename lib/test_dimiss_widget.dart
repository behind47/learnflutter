import 'package:flutter/material.dart';

class TestDismissWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(
          "test dismiss",
        )),
        body: Container(
          color: Colors.blue,
        ),
      ),
    );
  }
}
