import 'dart:math';
import 'package:flutter/material.dart';

/// 代码来自《Flutter开发之旅从南到北》——杨加康
class MultipleLayoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MultipleLayoutPageState();
}

class MultipleLayoutPageState extends State<MultipleLayoutPage> {
  @override
  Widget build(BuildContext context) {
    var childs = List.generate(
        10,
        (index) => _buildChild(
            Container(
              width: 30,
              height: 30,
              color: Colors.yellow,
            ),
            '$actionChild$index'));

    /// CustomMultiChildLayout继承MultiChildRenderObjectWidget，提供一个delegte用于实现子组件的布局逻辑。
    return Scaffold(
      appBar: AppBar(title: Text('多子组件布局')),
      body: CustomMultiChildLayout(
        delegate: new _CircularLayoutDelegate(
          itemCount: childs.length,
          radius: 80,
        ),
        children: childs,
      ),
    );
  }
}

final String actionChild = 'CHILD';
Widget _buildChild(Widget item, String id) {
  return LayoutId(id: id, child: item);
}

class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
// 子组件数量
  final int itemCount;
// 圆半径
  final double radius;
  late final _startAngle;
  late final _radiansPerDegree;
  late Offset center;

  _CircularLayoutDelegate({required this.itemCount, required this.radius}) {
    // 从-pi/2 ~ 3pi/2
    _radiansPerDegree = pi / 180;
    _startAngle = -90.0 * _radiansPerDegree;
  }

  /// 计算第index个子组件相对于起点转过的角度
  double _caculateItemAngle(int index) {
    double _itemSpacing = 360.0 / itemCount;
    return _startAngle + _itemSpacing * index * _radiansPerDegree;
  }

  /// layoutChild 用来为child添加约束
  /// positionChild 用来确定child在本布局中的偏移量
  /// 从而避免了对child的直接操作
  @override
  void performLayout(Size size) {
    center = Offset(size.width / 2, size.height / 2);
    for (int index = 0; index < itemCount; index++) {
      final String layoutId = '$actionChild$index';
      if (hasChild(layoutId)) {
        final Size childSize = layoutChild(layoutId, BoxConstraints.loose(size));
        final double itemAngle = _caculateItemAngle(index);
        positionChild(
          layoutId,
          Offset(
            center.dx - childSize.width / 2 + radius * cos(itemAngle),
            center.dy - childSize.height / 2 + radius * sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(covariant _CircularLayoutDelegate oldDelegate) {
    return itemCount != oldDelegate.itemCount || radius != oldDelegate.radius;
  }
}
