## ValueListenableBuilder

传入builder，然后在state里使用其作为build方法，从而将state保存的范围缩小到了ValueListenableBuilder对象。

```dart
class ValueListenableBuilder<T> extends StatefulWidget {
  const ValueListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.child,
  }) : assert(valueListenable != null),
       assert(builder != null),
       super(key: key);
}

class _ValueListenableBuilderState<T> extends State<ValueListenableBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
```

