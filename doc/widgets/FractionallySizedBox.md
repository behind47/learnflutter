## FractionallySizedBox

```dart
class FractionallySizedBox extends SingleChildRenderObjectWidget {
	const FractionallySizedBox({
		Key? key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
		Widget? child,
  }) : assert(alignment != null), assert(widthFactor == null || widthFactor >= 0.0), assert(heightFactor == null || heightFactor >= 0.0), super(key: key, child: child);
}
```

`factor`设置child的宽高为可用空间的比例，`alignment`设置child在可用空间内的对齐位置。

1. 如果`FractionallySizedBox`的尺寸为w * h，则设置child的尺寸为(w * widthFactor) * (h * heightFactor)
2. 随后根据`alignment`配合尺寸设置`child`的位置
3. 如果child是Container，则会覆盖其size，如果是IconData，由于其没有size属性，因此大小不会被改变，只会改变位置，且其位置相当于替换成Container计算得到的位置的center。



## OverflowBox

用来对child施加约束，约束的优先级高于child从parent获取到的约束，因而可能导致child溢出parent（当minWidth, minHeight超过parent提供的width, height时）。

```dart
class OverflowBox extends SingleChildRenderObjectWidget {
  const OverflowBox({
    Key? key,
    this.alignment = Alignment.center,
    this.minWidth, this.maxWidth, this.minHeight, this.maxHeight,
    Widget? child,
  }) : super(key: key, child: child);
}
```

