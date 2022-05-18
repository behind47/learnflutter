# PipelineOwner

管理绘制管线的owner

提供一个接口，驱动绘制管线，存储管线的每个阶段需要访问的render对象的状态。调用以下方法可以flush管线：

1. 【flushLayout】更新需要计算布局的render对象。此阶段会计算每个render对象的尺寸和位置。render对象可能将他们的绘制状态或组合状态标为dirty
2. 【flushCompositingBits】更新有组合状态有dirty标记的render对象。此阶段，每个render对象查找是否有需要组合的子节点。在绘制阶段，选择如何实现视觉效果比如剪裁时会用到这个信息。如果一个render对象有一个组合子节点，他需要使用一个【Layer】来创建裁剪，以便可以将这个裁剪应用到组合的子节点上
3. 【flushPaint】访问需要绘制的render对象。此阶段，render对象有机会记录绘制指令到【PictureLayer】和构建任何其他的组合【Layer】。
4. 最后，如果启用了语义，【flushSemantics】将为render对象编译语义信息。辅助技术使用语义信息来提升render树的可操作性。

【RendererBinding】持有负责屏幕上可见的render对象的pipeline owner。你可以创建其他pipeline owner来管理离屏对象，让离屏渲染对象能独立地flush自己的pipelines。

```dart
class PipelineOwner {
  
  final List<RenderObject> _nodesNeedingCompositingBitsUpdate = <RenderObject>[];
  // 需要绘制的render对象
  List<RenderObject> _nodesNeedingPaint = <RenderObject>[];
  
  void flushPaint() {
    final List<RenderObject> dirtyNodes = _nodesNeedingPaint;
    _nodesNeedingPaint = <RenderObject>[];
    // Sort the dirty nodes in reverse order (deepest first).
    for (final RenderObject node in dirtyNodes..sort((RenderObject a, RenderObject b) => b.depth - a.depth)) {
      if (node._needsPaint && node.owner == this) {
        if (node._layerHandle.layer!.attached) {
          // 绘制render对象
          PaintingContext.repaintCompositedChild(node);
        } else {
          node._skippedPaintingOnLayer();
        }
      }
    }
  }
  
  static void repaintCompositedChild(RenderObject child, { bool debugAlsoPaintedParent = false }) {
    _repaintCompositedChild(
      child,
      debugAlsoPaintedParent: debugAlsoPaintedParent,
    );
  }
  
  static void _repaintCompositedChild(
    RenderObject child, {
    bool debugAlsoPaintedParent = false,
    PaintingContext? childContext,
  }) {
    OffsetLayer? childLayer = child._layerHandle.layer as OffsetLayer?;
    if (childLayer == null) {
      // Not using the `layer` setter because the setter asserts that we not
      // replace the layer for repaint boundaries. That assertion does not
      // apply here because this is exactly the place designed to create a
      // layer for repaint boundaries.
      final OffsetLayer layer = OffsetLayer();
      child._layerHandle.layer = childLayer = layer;
    } else {
      childLayer.removeAllChildren();
    }
    childContext ??= PaintingContext(childLayer, child.paintBounds); // paintingContext里有canvas
    child._paintWithContext(childContext, Offset.zero);

    // Double-check that the paint method did not replace the layer (the first
    // check is done in the [layer] setter itself).
    childContext.stopRecordingIfNeeded();
  }
 	
  // 需要布局的render对象
  List<RenderObject> _nodesNeedingLayout = <RenderObject>[];
  
  void flushLayout() {
    // TODO(ianh): assert that we're not allowing previously dirty nodes to redirty themselves
    while (_nodesNeedingLayout.isNotEmpty) {
      final List<RenderObject> dirtyNodes = _nodesNeedingLayout;
      _nodesNeedingLayout = <RenderObject>[];
      for (final RenderObject node in dirtyNodes..sort((RenderObject a, RenderObject b) => a.depth - b.depth)) {
        if (node._needsLayout && node.owner == this)
          node._layoutWithoutResize();
      }
    }
  }
}
```



# RenderObject

```dart
class RenderObject {
  void markNeedsPaint() {
    if (_needsPaint)
      return;
    _needsPaint = true;
    if (isRepaintBoundary) {
      // If we always have our own layer, then we can just repaint
      // ourselves without involving any other nodes.
      if (owner != null) {
        owner!._nodesNeedingPaint.add(this);  // 标记需要绘制就是将render对象插入pipelineOwner的list
        owner!.requestVisualUpdate();
      }
    } else if (parent is RenderObject) {
      final RenderObject parent = this.parent! as RenderObject;
      parent.markNeedsPaint();
    } else {
      // If we're the root of the render tree (probably a RenderView),
      // then we have to paint ourselves, since nobody else can paint
      // us. We don't add ourselves to _nodesNeedingPaint in this
      // case, because the root is always told to paint regardless.
      if (owner != null)
        owner!.requestVisualUpdate();
    }
  }
  
  void markNeedsLayout() {
    if (_relayoutBoundary != this) {
      markParentNeedsLayout();
    } else {
      _needsLayout = true;
      if (owner != null) {
        owner!._nodesNeedingLayout.add(this); // 标记需要布局就是将render对象插入pipelineOwner的list
        owner!.requestVisualUpdate();
      }
    }
  }
  
  void _paintWithContext(PaintingContext context, Offset offset) {
    // If we still need layout, then that means that we were skipped in the
    // layout phase and therefore don't need painting. We might not know that
    // yet (that is, our layer might not have been detached yet), because the
    // same node that skipped us in layout is above us in the tree (obviously)
    // and therefore may not have had a chance to paint yet (since the tree
    // paints in reverse order). In particular this will happen if they have
    // a different layer, because there's a repaint boundary between us.
    if (_needsLayout)
      return;
    RenderObject? debugLastActivePaint;
    _needsPaint = false;
    try {
      paint(context, offset);
    } catch (e, stack) {
      _debugReportException('paint', e, stack);
    }
  }
  
  // 绘制render对象
  // 子类应该重写这个方法来提供视觉效果。
  // render对象的局部坐标系与context的canvas的坐标系的坐标轴方向相同
  // render对象的局部坐标系的原点被放在context的canvas的坐标系的offset的位置
  // 不要直接调用这个方法。如果你希望自定义绘制，调用[markNeedsPaint]来触发这个方法。
  // 如果你需要绘制一个子节点，调用context的[PaintingContext.paintChild]方法
  // 在绘制一个子节点的时候，当前的canvas的可能会改变，
  // 因为在绘制子节点之前的绘制操作，之后的绘制操作，需要被记录在不同的组合layer上
  void paint(PaintingContext context, Offset offset) { }
}
```



# PaintingContext

```dart
class PaintingContext {
  // 重绘给定的render对象
  // render对象必须绑定到一个[PipelineOwner]，必须有一个组合层，必须被绘制。
  // 在重绘时会重用渲染对象的layer（如果有的话），以及子树中不需要重新绘制的任何layer。
  static void repaintCompositedChild(RenderObject child, { bool debugAlsoPaintedParent = false }) {
    _repaintCompositedChild(
      child,
      debugAlsoPaintedParent: debugAlsoPaintedParent,
    );
  }
  
  static void _repaintCompositedChild(
    RenderObject child, {
    bool debugAlsoPaintedParent = false,
    PaintingContext? childContext,
  }) {
    OffsetLayer? childLayer = child._layerHandle.layer as OffsetLayer?;
    if (childLayer == null) {
      // Not using the `layer` setter because the setter asserts that we not
      // replace the layer for repaint boundaries. That assertion does not
      // apply here because this is exactly the place designed to create a
      // layer for repaint boundaries.
      final OffsetLayer layer = OffsetLayer();
      child._layerHandle.layer = childLayer = layer;
    } else {
      childLayer.removeAllChildren();
    }
    childContext ??= PaintingContext(childLayer, child.paintBounds);
    child._paintWithContext(childContext, Offset.zero);

    // Double-check that the paint method did not replace the layer (the first
    // check is done in the [layer] setter itself).
    childContext.stopRecordingIfNeeded();
  }
  
  // 如果child有自己的组合层，child会被组合到与paintingContext关联的layer子树
  // 否则，child将被绘制到这个context当前的PicturePlayer。
  void paintChild(RenderObject child, Offset offset) {
    if (!kReleaseMode && debugProfilePaintsEnabled)
      Timeline.startSync('${child.runtimeType}',
          arguments: timelineArgumentsIndicatingLandmarkEvent);

    if (child.isRepaintBoundary) {
      stopRecordingIfNeeded();
      _compositeChild(child, offset);
    } else {
      child._paintWithContext(this, offset);
    }

    if (!kReleaseMode && debugProfilePaintsEnabled) Timeline.finishSync();
  }
  
  void _compositeChild(RenderObject child, Offset offset) {
    // Create a layer for our child, and paint the child into it.
    if (child._needsPaint) {
      repaintCompositedChild(child, debugAlsoPaintedParent: true);
    } else {
      
    }
    final OffsetLayer childOffsetLayer =
        child._layerHandle.layer! as OffsetLayer;
    childOffsetLayer.offset = offset;
    appendLayer(childOffsetLayer);
  }

  @protected
  void appendLayer(Layer layer) {
    layer.remove();
    _containerLayer.append(layer);
  }
}
```



# CustomPainter

```dart
class CustomPainter {
  // 触发时判断是否需要重绘
  bool shouldRepaint(covariant CustomPainter oldDelegate);
  
  set foregroundPainter(CustomPainter? value) {
    if (_foregroundPainter == value) return;
    final CustomPainter? oldPainter = _foregroundPainter;
    _foregroundPainter = value;
    _didUpdatePainter(_foregroundPainter, oldPainter);
  }
  
  set painter(CustomPainter? value) {
    if (_painter == value) return;
    final CustomPainter? oldPainter = _painter;
    _painter = value;
    _didUpdatePainter(_painter, oldPainter);
  }
  
  final Listenable? _repaint;
  
  void _didUpdatePainter(CustomPainter? newPainter, CustomPainter? oldPainter) {
    // Check if we need to repaint.
    if (newPainter == null) {
      markNeedsPaint();
    } else if (oldPainter == null ||
        newPainter.runtimeType != oldPainter.runtimeType ||
        newPainter.shouldRepaint(oldPainter)) {
      markNeedsPaint();
    }
    if (attached) {
      oldPainter?.removeListener(markNeedsPaint);
      newPainter?.addListener(markNeedsPaint);
    }

    // Check if we need to rebuild semantics.
    if (newPainter == null) {
      if (attached) markNeedsSemanticsUpdate();
    } else if (oldPainter == null ||
        newPainter.runtimeType != oldPainter.runtimeType ||
        newPainter.shouldRebuildSemantics(oldPainter)) {
      markNeedsSemanticsUpdate();
    }
  }
}
```



# 触发`RenderCustomPaint`重绘的方式：

1. `set painter`触发`_didUpdatePainter(CustomPainter? newPainter, CustomPainter? oldPainter)`:
   1. 如果`newPainter`与`oldPainter`是同一个对象，则不触发重绘。
   2. 如果`newPainter`与`oldPainter`不是同一个类，则触发重绘。
   3. 如果`newPainter`与`oldPainter`是同一个类，但是`[newPainter.shouldRepaint] == true`，则触发重绘。
2. 父级`renderObject`的刷新，如果没有被`isRepaintBoundary`拦截，遍历到当前`RenderCustomPaint`时就会触发重绘。
3. 





2022年2月17日09:09
[摸鱼办]提醒您: 2月16日上午好，摸鱼
人!工作再累，一定不要忘记摸鱼哦!有事
没事起身去茶水间，去厕所，去廊道走走别
老在.工位.上坐着，钱是老板的,但命是自己
的。
距离[周末]还有:2天
距离[清明]还有 :47天
距离[五- -] 还有:73天
距离[端午]还有:106天
距离[中秋]还有:205天
距离[国庆]还有:226天
距离[元旦]还有:318天
.距离[春节]还有:339天
上班是帮老板赚钱，摸鱼是赚老板的钱!最
后，祝愿天下所有摸鱼人，都能愉快的渡过
每一天...