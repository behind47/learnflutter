import 'package:flutter/material.dart';

/// @param page 需要传入StatelessWidget或StatefulWidget的子集
  Container buildItem(BuildContext context, String? title, Widget page) => Container(
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