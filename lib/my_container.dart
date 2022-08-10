import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const moon = DecoratedBox(
        decoration: BoxDecoration(
            gradient: RadialGradient(
      // 填充DecoratedBox的颜色过渡
      center: Alignment(
          -0.5, -0.6), // 偏移区间在[-1.0, 1.0] * [-1.0, 1.0],[0,0]为canvas的圆心
      radius: 0.15,
      colors: <Color>[
        // colors配合stops使用，表示在半径为stops[i]处的颜色为colors[i],从而获得一系列不同色的同心环，相邻的两个环之间会填充自动过渡的颜色
        Color(0xffeeeeee),
        Color(0xff111133),
      ],
      stops: <double>[0.9, 1.0],
    )));

    // 1. child = null && constraints = null || unbounded, container填满父空间
    var nochild = Container(
      child: Container(
        color: Colors.blue,
        child: CircleAvatar(
          radius: 5,
          backgroundColor: Colors.yellow,
        ),
        alignment: Alignment.topLeft,
      ),
      constraints: BoxConstraints(),
    );
    // 2. child = null && contraints = bounded constraints
    return nochild;
  }
}
