## CustomPainter

[CustomPaint]和[RenderCustomPaint]使用的接口

实现一个自定义painter的方式是，继承或实现这个接口，自定义paint delegate。

[CustomPaint]子类**必须**实现[paint]和[shouldRepaint]方法，**可以**实现[hitTest]和[shouldRebuildSemantics]方法，以及[semanticsBuilder] getter

当自定义对象需要被重绘时调用[paint]

当该类的一个新的实例被提供时，会调用[shouldRepaint]方法来检查新的实例是否表示不同的信息。

触发重绘最有效率的方法有两种：

1. 继承该类，提供一个`repaint`参数给[CustomPainter]的构造器，当需要重绘时，这个对象会通知它的监听者。
2. 继承[Listenable]，实现[CustomPainter]，以便对象自己可以直接提供通知。

这两种情况下，[CustomPaint] widget 或[RenderCustomPaint]渲染对象都会监听[Listenable]，在animation ticks时重绘，避免pipeline的构建和布局阶段。

当用户与潜在的绘制对象交互的时候，会触发[hitTest]方法，来决定用户是否点击到了对象上。

当自定义对象需要重建它的语义信息的时候，会调用[semanticsBuilder]

当该类的一个新的实例被提供的时候会调用[shouldRebuildSemantics]来检查是否新的实例包含了会影响语义树的不同信息。

```dart
abstract class CustomPainter extends Listenable {
  const CustomPainter({ Listenable? repaint }) : _repaint = repaint;
  
  final Listenable? _repaint;
  /// 屏幕外的图形操作是不确定的，裁剪或不裁剪都有可能。有时候很难保证图形操作在屏幕内（比如当操作范围是用户输入动态决定的场景），此时可以在paint之前调用[Canvas.clipRect]获取屏幕内的有效绘制区域，以保证接下来的操作都只发生在屏幕范围内。
	/// 避免在paint方法里调用[Canvas.save]/[Canvas.saveLayer] and [Canvas.restore]，否则在canvas上发生的所有子序列的绘制都会被影响，造成奇怪的结果。
	/// 如果要在[Canvas]上绘制文本，使用[TextPainter]
	/// 如果要绘制图像：
	/// 1. 获取[ImageStream]，比如在[AssetImage]或[NetworkImage]对象上调用[ImageProvider.resolve]。
	/// 2. 当[ImageStream]的潜在的[ImageInfo]对象改变的时候，创建一个新的自定义paint delegate的实例，传入[ImageInfo]对象。
	/// 3. 在你的delegate的[paint]方法内，调用[Canvas.drawImage]，[Canvas.drawImageRect], or [Canvas.drawImageNine]方法来绘制[ImageInfo.image]对象，使用[ImageInfo.scale]来获取正确的渲染尺寸。
  void paint(Canvas canvas, Size size);
  /// 在自定义painter delegate的新实例被添加到[RenderCustomPaint]对象,或者使用一个自定义的painter delegate新实例创建一个新的[CustomPaint]对象的时候调用.
  /// 如果新的实例与旧的实例代表了不同的信息，那么该方法会返回true，否则它应该返回false
  /// 如果返回false，[paint]调用可能不执行。但是可能调用，比如，如果一个祖先或后代需要被绘制，即便返回false也会调用[paint]。也可能不调用[shouldRepaint]，而是直接调用[paint]方法，比如box改变size的时候。
  /// 如果一个自定义delegate有一个特别昂贵的paint方法，以至于要尽量避免重绘，那么可以使用[RepaintBoundary]或[RenderRepaintBoundary](或者其他render对象，其属性[RenderObject.isRepaintBoundary] = true)
  bool shouldRepaint(covariant CustomPainter oldDelegate);
}
```



## Canvas

```dart
class Canvas extends NativeFieldWrapperClass2 {
  /// 将clip区域减小到当前的clip区域与给定的矩形的交集
  /// 如果[doAntiAlias] = true, 那么clip将会anti-aliased
  /// 如果多个绘制操作与clip边界关联，这可能导致与边界的不正确的混合。[saveLayer]给出了如何确定绘制边界的讨论。
  /// 使用[ClipOp.difference]来从当前的clip减去给定的矩形。
  void clipRect(Rect rect, { ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true }) {
    assert(_rectIsValid(rect));
    assert(clipOp != null);
    assert(doAntiAlias != null);
    _clipRect(rect.left, rect.top, rect.right, rect.bottom, clipOp.index, doAntiAlias);
  }
}
```



## Listenable

维护一个listeners列表，常用于通知客户端更新。

```dart
abstract class Listenable {
  
}
```

