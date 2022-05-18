## NestedScrollView

一个scrollView，内部可以嵌套其他scrollView，并且二者的滚动位置存在关联性。

最常用的场景DDDD

scrollview - silver - tabbarview - list

list不能与scrollview交互，即list划到顶部后scrollview不会上滑

```dart
/// NestedScrollView - silver - tabbarview - list
class NestedScrollView extends StatefulWidget {
  const NestedScrollView({
    Key? key,
    this.controller, // 控制scrollView的滚动目标位置
    this.scrollDirection = Anix.vertical, // 滚动轴
    this.reverse = false, //滑动手势与滚动方向是否相反
    this.physics, // TODO
    required this.headerSliverBuilder, //显示在scrollview里的silver
    required this.body, //list
    this.dragStartBehavior = DragStartBehavior.start,
    this.floatHeaderSlivers = false, // 回滚的时候是否优先处理scrollView
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
  })
}
```



### `SliverOverlapAbsorber + SliverOverlapInjector`

overlap 交叠

absorber 阻尼器

Injector 注射机

```dart
/// A sliver that wraps another, forcing its layout extent to be treated as overlap.
class SliverOverlapAbsorber extends SingleChildRenderObjectWidget {
  const SliverOverlapAbsorber({
    Key? key,
    required this.handle,
    Widget? sliver,
  })
    
    // 记录absorber overlap，与SliverOverlapAbsorber一一对应
  final SliverOverlapAbsorberHandle handle;
}
```

```dart
/// A sliver that has a sliver geometry based on the values stored in a SliverOverlapAbsorberHandle.
class SliverOverlapInjector extends SingleChildRenderObjectWidget {
  const SliverOverlapInjector({
    Key? key,
    required this.handle,
    Widget? sliver,
  })
    
    // 与absorber对应的handle
    final SliverOverlapAbsorberHandle handle;
}
```

`SliverOverlapAbsorber`和`SliverOverlapInjector`具有同一个祖先`Viewport`，且前者是一个相对较早的子孙节点，所以在每一帧里`absorber`都要比`injector`先展开。
