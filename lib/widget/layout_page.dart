import 'package:flutter/material.dart';
import 'package:learnflutter/util/router_utils.dart';
import 'package:learnflutter/widget/multiple_layout_page.dart';
import 'package:learnflutter/widget/my_custom_scroll_view.dart';
import 'package:learnflutter/widget/single_layout_page.dart';

class LayoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LayoutPageState();
}

class LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('布局过渡页')),
      body: ListView(
        children: [
          buildItem(context, '单子组件布局', SingleLayoutPage()),
          buildItem(context, '多子组件布局', MultipleLayoutPage()),
          buildItem(context, '滑动组件布局', MyCusScrollView())
        ],
      ),
    );
  }
}
