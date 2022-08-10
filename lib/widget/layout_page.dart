import 'package:flutter/material.dart';
import 'package:learnflutter/util/routerUtils.dart';
import 'package:learnflutter/widget/MultipleLayoutPage.dart';
import 'package:learnflutter/widget/SingleLayoutPage.dart';

class LayoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LayoutPageState();
}

class LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildItem(context, '单子组件布局', SingleLayoutPage()),
        buildItem(context, '多子组件布局', MultipleLayoutPage()),
      ],
    );
  }
}