import 'package:flutter/material.dart';

class MyFractionallySizedBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyFractionallySizedBoxState();
  }
}

class MyFractionallySizedBoxState extends State<MyFractionallySizedBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyFractionallySizedBox'),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                color: Colors.yellow,
                child: FractionallySizedBox(
                  heightFactor: .8,
                  widthFactor: .6,
                  alignment: FractionalOffset.topRight,
                  child: Container(
                    child: Icon(Icons.circle),
                    color: Colors.blue,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                height: 200,
                width: 200,
                child: OverflowBox(
                  minHeight: 50,
                  minWidth: 250,
                  maxHeight: 300,
                  maxWidth: 300,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.green,
                    child: Text('overflow'),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
