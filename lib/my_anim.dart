import 'package:flutter/material.dart';

class MyAnim extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAnimState();
  }
}

class MyAnimState extends State<MyAnim> with TickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation _animation;
  // late Tween _tween;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
    AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight)
        .chain(CurveTween(curve: Curves.easeIn));
    // _tween = IntTween();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
