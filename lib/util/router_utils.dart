import 'package:flutter/material.dart';

/// @param page 需要传入StatelessWidget或StatefulWidget的子集
Container buildItem(BuildContext context, String? title, String route,{String? arguments}) =>
    Container(
      height: 50,
      color: Colors.blue,
      child: GestureDetector(
        child: Center(
          child: Text(title ?? ""),
        ),
        onTap: () => Navigator.pushNamed(context, route, arguments: arguments),
      ),
    );
