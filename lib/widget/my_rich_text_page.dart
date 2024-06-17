import 'package:flutter/material.dart';

class MyRichTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rich text page'),
      ),
      body: Text.rich(
        TextSpan(
          text:
              'aksldjg aksldjg aksldjg aksldjg aksldjg aksldjg aksldjg aksldjg aksldjg',
          style: TextStyle(
            color: Colors.green,
            backgroundColor: Colors.red,
            height: 1,
          ),
          children: [
            TextSpan(text: '测试字段'),
            TextSpan(text: 'english'),
            WidgetSpan(
                child: Image.asset(
                  'assets/arrow-right.png',
                  height: 25,
                ),
                style: TextStyle(backgroundColor: Colors.blue))
          ],
        ),
        softWrap: true,
        textScaler: TextScaler.linear(1),
        maxLines: 3,
        textWidthBasis: TextWidthBasis.parent,
        style: TextStyle(backgroundColor: Colors.green),
        textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.even),
      ),
    );
  }
}
