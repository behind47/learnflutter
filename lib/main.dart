import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learnflutter/entry_list.dart';
import 'package:learnflutter/ffi/native_add_page.dart';
import 'package:learnflutter/introducation/introducation_page.dart';
import 'package:learnflutter/my_app.dart';
import 'package:learnflutter/my_capture_page.dart';
import 'package:learnflutter/my_container.dart';
import 'package:learnflutter/my_tabbar_view.dart';
import 'package:learnflutter/paint/paint_page.dart';
import 'package:learnflutter/widget/layout_page.dart';
import 'package:learnflutter/widget/multiple_layout_page.dart';
import 'package:learnflutter/widget/my_custom_scroll_view.dart';
import 'package:learnflutter/widget/my_farctionally_sized_box.dart';
import 'package:learnflutter/widget/my_nested_list.dart';
import 'package:learnflutter/widget/my_rich_text_page.dart';
import 'package:learnflutter/widget/single_layout_page.dart';

// void main() {
//   debugRepaintRainbowEnabled = true;
//   runApp(const MaterialApp(
//     title: 'materialApp',
//     home: IndexPage(),
//   ));
// }

// class IndexPage extends StatelessWidget {
//   const IndexPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("indexPage"),
//       ),
//       body: Center(
//         child: EntryList(),
//       ),
//     );
//   }
// }

void main() {
  debugRepaintRainbowEnabled = true;
  runApp(IndexPage());
}

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'materialApp',
    home: Scaffold(
      appBar: AppBar(
        title: const Text("indexPage"),
      ),
      body: Center(
        child: EntryList(),
      ),
    ),
    routes: <String, WidgetBuilder> {
      '/myapp':(context) => MyApp(),
      '/introducation':(context) => IntroducationPage(),
      '/layout':(context) => LayoutPage(),
      '/tabBarView':(context) => MyTabBarView(),
      '/customScrollView':(context) => MyCusScrollView(),
      '/container':(context) => MyContainer(),
      '/expanded':(context) =>  MyExpanded(),
      '/sizedBox':(context) => MyFractionallySizedBox(),
      '/nestedList':(context) => MyNestedList(),
      '/richText':(context) => MyRichTextPage(),
      '/capture':(context) =>  MyCapturePage(),
      '/paint':(context) => PaintPage(),
      '/nativeAdd':(context) => NativeAddPage(),
      '/singleLayout':(context) => SingleLayoutPage(),
      '/multipleLayout':(context) => MultipleLayoutPage(),
    },
  );
  }
}
