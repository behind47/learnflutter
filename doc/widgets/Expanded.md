## Expanded

```dart
class Expanded extends Flexible {
  const Expaned({
    Key? key,
    int flex = 1,
    required Widget child,
  }) : super(Key: key, flex: flex, fit: FlexFit.tight, child: child);
}

enum FlexFit {
  tight, // child被强制填满可用的空间
  loose, // child最多填满可用的空间，也可以不填满
}
```

使用要求：

1. 必须用于包裹`Row`, `Column`,`Flex`（后面只用Flex代替这三个）中的子元素，也就是`Flex`-`Expanded`-`Widget`的关系。
2. 从`Expanded`到`Flex`的路径上只能有`StatelessWidget`或`StatefullWidget`

## Flexible

与Expanded相对，不强制child占满父空间的Widget

```dart
class Flexible extends ParentDataWidget<FlexParentData> {
  const Flexible({
    Key? key,
    this.flex = 1,
    this.fit = FlexFit.loose,
    required Widget child,
  }) : super(key: key, child: child);
}
```

