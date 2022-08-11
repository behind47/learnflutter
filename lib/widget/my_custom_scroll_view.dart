import 'dart:math';

import 'package:flutter/material.dart';

/// CustomScrollView 是一个使用slivers创建自定义滚动效果的scrollView
/// lists, grids, expanding headers(指下拉展开，上滑收缩的appBar)
/// slivers里的widgets必须生产RenderView对象
/// 使用controller的ScrollController.initialScrollOffset属性来控制scroll view的初始滚动位置

// 使用一个scroll view 包含一个灵活的 pinned app bar，一个 grid，一个无限list
class MyCusScrollView extends StatelessWidget {
  final cusScrollView1 = CustomScrollView(
    slivers: <Widget>[
      const SliverAppBar(
        pinned: true,
        expandedHeight: 250.0,
        flexibleSpace: FlexibleSpaceBar(
          title: Text('sliver app bar'),
        ),
      ),
      SliverGrid(
        delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text(
                    'Grid Item $index',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
            childCount: 20),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0),
      ),
      makePersistentHeader('persistent header'),
      SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: Text(
                      'List Item $index',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
              childCount: 20),
          itemExtent: 50.0)
    ],
  );

  static final top = <int>[1, 3, 5, 7, 9];
  static final bottom = <int>[2, 4, 6, 8, 10];
  static final centerKey = Key("cusScrollView2");
  final cusScrollView2 = CustomScrollView(
    center: centerKey,
    slivers: [
      SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((context, index) => Container(
                alignment: Alignment.center,
                color: Colors.blue[100 * top[index % top.length]],
                child: Text(
                  'List Item $index',
                  style: TextStyle(fontSize: 10),
                ),
              )),
          itemExtent: 5.0),
      SliverFixedExtentList(
          key: centerKey,
          delegate: SliverChildBuilderDelegate((context, index) => Container(
                alignment: Alignment.center,
                color: Colors.blue[100 * bottom[index % bottom.length]],
                child: Text(
                  'List Item $index',
                  style: TextStyle(fontSize: 10),
                ),
              )),
          itemExtent: 50.0),
    ],
  );

  @override
  Widget build(BuildContext context) => cusScrollView1;
}

SliverPersistentHeader makePersistentHeader(String headerText) {
  return SliverPersistentHeader(
    pinned: true,
    delegate: _SliverAppBarDelegate(
      minHeight: 60.0,
      maxHeight: 200.0,
      child: Container(
        color: Colors.lightBlue,
        child: Center(
          child: Text(headerText, style: TextStyle(fontSize: 18),),
        ),
      ),
    ),
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
