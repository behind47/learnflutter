## CustomPaint

在paint phase提供canvas用户绘制的widget。

需要paint的时候，[CustomPaint]先使用它的[painter]在当前的canvas上绘制，然后把paint指令发给child，绘制完成后，再让[foregroundPainter]绘制。canvas的坐标系与[CustomPaint]对象的坐标系一致。painters可用的绘制区域是一个从坐标原点开始的矩形，如果painters在这个矩形区域外绘制，可能没有足够的内存能光栅化绘制指令，结果不可测。将[CustomPaint]包含在[ClipRect] widget里可以保证绘制在矩形区域内发生。

因为自定义paint在paint期间调用它的painters，你不能在callback期间调用`setState`或`markNeedsLayout`（这一帧的layout已经发生了）



```dart
class CustomPaint extends SingleChildRenderObjectWidget {
  
}
```





## RenderCustomPaint

attach的时候向`repaint`里添加了`markNeedsPaint`监听器，ticker每一帧的tick方法里都会执行`repaint`的监听器，将当前的RenderObject标记为dirty，从而触发重绘。

```dart
class RenderCustomPaint extends RenderProxyBox {
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _painter?.addListener(markNeedsPaint);
    _foregroundPainter?.addListener(markNeedsPaint);
  }
}

abstract class CustomPainter extends Listenable {
  final Listenable? _repaint;
  
  @override
  void addListener(VoidCallback listener) => _repaint?.addListener(listener);
}
```

