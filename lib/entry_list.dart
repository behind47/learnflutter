import 'package:learnflutter/my_app.dart';
import 'package:learnflutter/my_container.dart';
import 'package:learnflutter/my_custom_scroll_view.dart';
import 'package:learnflutter/my_tabbar_view.dart';
import 'package:learnflutter/ffi/native_add_page.dart';
import 'package:learnflutter/introducation/introducation_page.dart';
import 'package:learnflutter/paint/paint_page.dart';
import 'package:learnflutter/util/router_utils.dart';
import 'package:learnflutter/widget/layout_page.dart';
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
            buildItem(context, "MyApp", MyApp()),
            buildItem(context, '简历模版', IntroducationPage()),
            buildItem(context, '布局约束实践', LayoutPage()),
            buildItem(context, "MyTabBarView", MyTabBarView()),
            buildItem(context, "MyCusScrollView", MyCusScrollView()),
            buildItem(context, "Container", MyContainer()),
            buildItem(context, 'Expanded', MyExpanded()),
            buildItem(context, 'MyFractionallySizedBox', MyFractionallySizedBox()),
            buildItem(context, 'MyNestedList', MyNestedList()),
            buildItem(context, '富文本', MyRichTextPage()),
            buildItem(context, '截图', MyCapturePage()),
            buildItem(context, '绘制', PaintPage()),
            buildItem(context, 'FFI', NativeAddPage()),
          ],
        ))
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
