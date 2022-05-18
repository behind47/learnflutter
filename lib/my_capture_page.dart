import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyCapturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyCapturePageState();
  }
}

class MyCapturePageState extends State<MyCapturePage> {
  GlobalKey rootWidgetKey = GlobalKey(); //TODO:试试普通string

  List<Uint8List> images = []; // 用来传递截图到显示

// 使用RepaintBoundary组件截图,将其套在想要截图的组件外层
  Future<Uint8List?> _capturePng(BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary = rootWidgetKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary?.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);
      ByteData? byteData = await image?.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes != null) {
        setState(() {
          images.add(pngBytes);
        });
      }
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageURL =
        "https://picography.co/wp-content/uploads/2021/12/picography-snowy-peaks-from-aircraft-window-768x432.jpg";

    return Scaffold(
        appBar: AppBar(
          title: Text('截图'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                child: CustomPaint(
                  painter: ShapePainter(color: Colors.blue),
                ),
              ),
              Container(
                height: 900,
                color: Colors.green,
              ),
            ],
          ),
        )
        // RepaintBoundary(
        //   key: rootWidgetKey,
        //   child: ListView(children: [
        //     Column(
        //     children: [
        //       Image.network(
        //         imageURL,
        //         width: 300,
        //         height: 300,
        //       ),
        //       TextButton(
        //           onPressed: () => _capturePng(context), child: Text("截屏")),
        //       if (images.isNotEmpty)
        //       SizedBox(
        //         height: 100,
        //           child: ListView.builder(
        //             itemBuilder: (context, index) => Container(child: Image.memory(
        //               images[index],
        //               fit: BoxFit.cover,
        //             ), color: Colors.yellow,),
        //             itemCount: images.length,
        //             scrollDirection: Axis.horizontal,
        //           ),
        //       ),
        //       Container(color: Colors.blue, width: 100, height: 100,),
        //     ],
        //   ),
        // ],)

        //   )
        );
  }
}

class ShapePainter extends CustomPainter {
  final Color color;
  ShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    print('-----paint-----${color.value}-----${DateTime.now()}-----');
    Paint paint = Paint()..color = color;
    canvas.drawCircle(Offset(80, 80), 50, paint);
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
