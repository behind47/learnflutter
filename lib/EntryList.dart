import 'package:demo/MyApp.dart';
import 'package:demo/MyTabbarView.dart';
import 'package:flutter/material.dart';

class EntryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EntryListState();
}

class EntryListState extends State<EntryList> {
  List itemList = [];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            buildItem(
              "MyApp",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              ),
            ),
            buildItem(
              "MyTabBarView",
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyTabBarView(),
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }

  Container buildItem(String? title, Function()? tap) => Container(
        height: 50,
        color: Colors.blue,
        child: GestureDetector(
          child: Center(
            child: Text(title ?? ""),
          ),
          onTap: tap,
        ),
      );
}
