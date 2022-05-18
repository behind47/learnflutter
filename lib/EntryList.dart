import 'package:learnflutter/MyApp.dart';
import 'package:learnflutter/MyContainer.dart';
import 'package:learnflutter/MyCusScrollView.dart';
import 'package:learnflutter/MyTabbarView.dart';
import 'package:learnflutter/ffi/native_add_page.dart';
import 'package:learnflutter/paint/paint_page.dart';
import 'package:learnflutter/widget/my_farctionally_sized_box.dart';
import 'package:learnflutter/widget/my_nested_list.dart';
import 'package:learnflutter/widget/my_rich_text_page.dart';
import 'package:flutter/material.dart';

import 'my_capture_page.dart';

class EntryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EntryListState();
}

class EntryListState extends State<EntryList> {
  List itemList = [];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        return route.didPop(result);
      },
      pages: [
        MaterialPage(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            buildItem("MyApp", MyApp()),
            buildItem("MyTabBarView", MyTabBarView()),
            buildItem("MyCusScrollView", MyCusScrollView()),
            buildItem("Container", MyContainer()),
            buildItem('Expanded', MyExpanded()),
            buildItem('MyFractionallySizedBox', MyFractionallySizedBox()),
            buildItem('MyNestedList', MyNestedList()),
            buildItem('富文本', MyRichTextPage()),
            buildItem('截图', MyCapturePage()),
            buildItem('绘制', PaintPage()),
            buildItem('FFI', NativeAddPage()),
          ],
        ))
      ],
    );
  }

  /// @param page 需要传入StatelessWidget或StatefulWidget的子集
  Container buildItem(String? title, Widget page) => Container(
        height: 50,
        color: Colors.blue,
        child: GestureDetector(
          child: Center(
            child: Text(title ?? ""),
          ),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => page)),
        ),
      );
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
