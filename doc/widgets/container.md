## DecorateBox

`decoration`可以认为是一个图像，`DecoratedBox`提供`decoration`支持

```dart
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A widget that paints a [Decoration] either before or after its child paints.
class DecorateBox extends SingleChildRenderObjectWidget {
  const DecoratedBox({
    Key? key,
    required this.decoration,
    this.position = DecorationPosition.background,//位置默认在最下层，也可以改成最上层，比如做蒙层
    Widget? child,//子元素可以为空
  }) : assert(decoration != null),
  assert(position != null),
  super(key: key, child: child);
}

enum DecorationPosition {
  /// Paint the box decoration behind the children.
  background,

  /// Paint the box decoration in front of the children.
  foreground,
}
```

1. 常与`BoxDecoration`配合使用
2. 如果需要将子节点剪裁成特定形状，可以使用`ShapeDecoration`，配合`ClipPath`

使用例子

```dart
// 绘制圆月
const moon = DecoratedBox(
        decoration: BoxDecoration(
            gradient: RadialGradient(
      // 填充DecoratedBox的颜色过渡
      center: Alignment(
          -0.5, -0.6), // 偏移区间在[-1.0, 1.0] * [-1.0, 1.0],[0,0]为canvas的圆心
      radius: 0.15,
      colors: <Color>[
        // colors配合stops使用，表示在半径为stops[i]处的颜色为colors[i],从而获得一系列不同色的同心环，相邻的两个环之间会填充自动过渡的颜色
        Color(0xffeeeeee),
        Color(0xff111133),
      ],
      stops: <double>[0.9, 1.0],
    )));
```



## SingleChildRenderObjectWidget

```dart
abstract class SingleChildRenderObjectWidget extends RenderObjectWidget {
	const SingleChildRenderObjectWidget({Key? key, this.child}) : super(key: key);
  // 提供对一个子元素的存储支持
  final Widget? child;
}
```



## Container

```dart
/// A widget that combines common paiting, positioning, and sizing widgets.
class Container extends StatelessWidget {
  Container({
    Key? key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,//使用约束来占满父元素或者限制在一定范围内
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  })
}
```

影响因素:

1. child
2. parent提供的constraints
3. alignment
4. constraints，由`width` + `height`组成，约束在padding外，margin内

### layout behavior

1. 使用 alignment 排序
2. 使用 width, height 修改 child 的尺寸
3. 使用 constraints 规定 container 尽可能大 还是 尽可能小

| parent提供的constraints | child | constraints       | alignment |                      |
| ----------------------- | ----- | ----------------- | --------- | -------------------- |
|unbounded| -| -| -| 尽可能小|
|bounded| null|null|null|占满parent提供的constraints|
|unbounded|-|-|nonnull|包裹child|
|bounded|-|-|nonnull|占满父空间，基于alignment对齐child|
|-|nonnull|null|null|使用parent提供的constraints直接约束child|
| - | null | nonnull | Null | 在满足parent提供的constraints和自身constraints的前提下尽可能小|
| null                    | Null  | null or unbounded | -         | 尽可能大，占满父空间 |
| null | nonnull | - | nonnull | 占满父空间，基于alignment对齐child |
|                         |       |                   |           |                      |

需要测试的点:

1. parent提供的constraints
2. `container`默认不响应点击，如果设置了`color`，则点击会被`ColoredBox`处理。如果设置了`decoration`或者`foregroundDecoration`，则点击会被`Decoration.hitTest`处理。

### BoxConstaints

用于`renderObject`布局的`immutable`的布局约束

```dart
class BoxConstraints extends Constraints {
  const BoxConstraints({
 		this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });
}
```

