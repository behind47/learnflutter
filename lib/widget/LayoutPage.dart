import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 代码来自《Flutter开发之旅从南到北》——杨加康
class LayoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LayoutPageState();
}

/// 布局流程：
/// 1. CustomCenter从父组件Container接收到constraints
/// 2. 走CustomCenter的performLayout布局逻辑，CustomCenter的size始终使用constraints.max，并更新constraints传给子组件
/// 3. CustomCenter的子组件是Container，设置了width，会从CustomCenter传来的constraints里寻找最接近width的值作为constraints.minWidth与constraints.maxWidth，height同理。
/// 于是子组件的constraints = {minWidth:100,maxWidth:100,minHeight:100,maxHeight:100}。
/// 至此CustomCenter与子组件CustomCenter的尺寸都确定了，于是可以确定子组件Container在CustomCenter中的坐标。
class LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('布局约束实践'),
      ),
      body: Container(
        color: Colors.blue,
        constraints: BoxConstraints(
            maxHeight: double.infinity,
            minHeight: 200.0,
            maxWidth: double.infinity,
            minWidth: 200.0), // constraints会传给child
        child: CustomCenter(
          child: Container(width: 100, height: 100, color: Colors.red,), // 如果设置了width，会从constraints里找到最接近width的值作为minWidth和maxWidth，height同理
        ),
      ),
    );
  }
}

/// 实现Center的功能
class CustomCenter extends SingleChildRenderObjectWidget {
  CustomCenter({Widget? child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomCenter();
  }
}

class RenderCustomCenter extends RenderShiftedBox {
  RenderCustomCenter() : super(null);

  @override
  void performLayout() {
    if (child != null) {
      // 继续向子组件传递布局约束
      child!.layout(
          BoxConstraints(
              minWidth: 0.0,
              maxWidth: constraints.maxHeight, // constraints是父组件往下传递来的
              minHeight: 0.0,
              maxHeight: constraints.maxHeight),
          parentUsesSize: true);// parentUsesSize打开，表示布局组件需要根据子组件的大小做调整
      size = Size(constraints.maxWidth,
          constraints.maxHeight); // 定义本组件的大小: 不同组件的逻辑不同,Center取最大约束
      centerChild();
    } else {
      size = Size(constraints.maxWidth,
          constraints.maxHeight); // 定义本组件的大小: 不同组件的逻辑不同,Center取最大约束
    }
    super.performLayout();
  }

  /// 设置子组件偏移
  void centerChild() {
    final double centerX = (size.width - child!.size.width) / 2.0;
    final double centerY = (size.height - child!.size.height) / 2.0;
    // 指定子组件的偏移量
    final BoxParentData childParentdata = child!.parentData as BoxParentData;
    childParentdata.offset = Offset(centerX, centerY);// 修改子组件传来的布局信息的属性修改子组件的位置 
  }
}
