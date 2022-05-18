import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaintPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaintPageState();
  }
}

class PaintPageState extends State<PaintPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(_update);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            /// 每一帧通过repaint参数触发重绘
            CustomPaint(
              size: Size(100, 100),
              painter: ShapePainter2(factor: _controller),
            ),

            /// 每一帧通过ticker触发setState刷新ValueListenableBuilder，缩小了刷新的范围
            // ValueListenableBuilder(
            //   builder: (controller, value, child) => CustomPaint(
            //     size: Size(100, 100),
            //     painter: ShapePainter(
            //         color:
            //             Color.lerp(Colors.red, Colors.blue, _controller.value)),
            //   ),
            //   valueListenable: _controller,
            // ),

            /// 每一帧通过ticker触发setState刷新PaintPageState
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: CustomPaint(
            //     size: Size(100, 100),
            //     painter: ShapePainter(color: Color.lerp(Colors.red, Colors.blue, _controller.value)),
            //   ),
            // ),

            CupertinoActivityIndicator(),
          ],
        ));
  }
}

class ShapePainter extends CustomPainter {
  final Color? color;

  ShapePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    print(
        '-----paint-----${this}-----${color?.value}-----${DateTime.now()}-----');
    Paint paint = Paint()..color = color ?? Colors.red;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class ShapePainter2 extends CustomPainter {
  final Color? color;
  final Animation<double>? factor;

  ShapePainter2({this.color, this.factor}) : super(repaint: factor);

  @override
  void paint(Canvas canvas, Size size) {
    print(
        '-----paint-----${this}-----${color?.value}-----${DateTime.now()}-----');
    Paint paint = Paint()
      ..color =
          Color.lerp(Colors.red, Colors.blue, factor?.value ?? 0) ?? Colors.red;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant ShapePainter2 oldDelegate) {
    return oldDelegate.factor != factor;
  }
}
