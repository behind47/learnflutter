import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learnflutter/entry_list.dart';

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
  runApp(const MaterialApp(
    title: 'materialApp',
    home: IndexPage(),
  ));
}

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("indexPage"),
      ),
      body: Center(
        child: EntryList(),
      ),
    );
  }
}
