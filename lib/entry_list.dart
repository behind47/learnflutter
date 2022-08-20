import 'package:learnflutter/util/router_utils.dart';
import 'package:flutter/material.dart';


class EntryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EntryListState();
}

class EntryListState extends State<EntryList> {
  List itemList = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            buildItem(context, 'MyApp', '/myapp'),
            buildItem(context, '简历模版', '/introducation'),
            buildItem(context, '布局约束实践', '/layout'),
            buildItem(context, "MyTabBarView", '/tabBarView'),
            buildItem(context, "MyCusScrollView", '/customScrollView'),
            buildItem(context, "Container", '/container'),
            buildItem(context, 'Expanded','/expanded'),
            buildItem(context, 'MyFractionallySizedBox', '/sizedBox'),
            buildItem(context, 'MyNestedList', '/nestedList'),
            buildItem(context, '富文本', '/richText'),
            buildItem(context, '截图','/capture'),
            buildItem(context, '绘制', '/paint'),
            buildItem(context, 'FFI', '/nativeAdd'),
          ],
    );
  }
}

class MyExpanded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ep1 = Scaffold(
      appBar: AppBar(
        title: const Text('Expanded Column sample'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              height: 100,
              width: 100,
            ),
            Expanded(
                child: Container(
              color: Colors.amber,
              width: 100,
            )),
            Container(
              color: Colors.blue,
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
    return ep1;
  }
}
