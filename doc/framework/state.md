# State

```dart
@optionalTypeArgs
abstract class State<T extends StatefulWidget> with Diagnosticable {
  // 通知framework，对象的内部状态改变了。
  // 提供的callback会马上被同步调用。没有设计为异步是因为异步操作不能确定state改变的时机。把且仅把需要更新的状态放在callback里，避免把IO等异步操作放在里面。
  // 调用【setState】通知framework——"这个对象的内部状态已经改变了，可能会影响子树里的UI", framework会为这个【State】开启一个【build】
  // 如果你修改了状态（对象的属性），但是没有调用【setState】，framework可能不会启动【build】，子树的UI也不会随之更新
  // 在dispose之后调用【setState】会导致异常。有时候widget会被提前回收，为了避免异常可以在【setState】之前检查【mounted】来判断widget是否还存在。
  @protected
  void setState(VoidCallback callback) {
    final Object? result = callback() as dynamic;
    _element!.markNeedsBuild();
  }
}
```



# Element

```dart
bool get dirty => _dirty; // 标志为true时会在下一帧重建

// 将element标记为dirty，添加到widget的全局list，在下一帧重建。
void markNeedsBuild() {
  // 因为在一帧里重建一个element两次没有效率，应用和widgets只有在每一帧开始前别标记为dirty才会重建，在一帧中被标记不会重建。
  if (_lifecycleState != _ElementLifecycle.active) return;
  if (dirty) return;
  _dirty = true;
  owner!.scheduleBuildFor(this);
}

// 调用来源：
// 1. 调用[BuildOwner.scheduleBuildFor]来标记这个element为dirty
// 2. 调用[mount]，在这个element初次构建的时候
// 3. 调用[update]，在widget改变的时候。
@pragma('vm:prefer-inline')
void rebuild() {
	if (_lifecycleState != _ElementLifecycle.active || !_dirty) return;
  Element? debugPreviousBuildTarget;
  performRebuild();
}

@protected
void performRebuild();

@protected
@pragma('vm:prefer-inline')
Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) {
  if (newWidget == null) {
    if (child != null) deactivateChild(child);
    return null;
  }
  final Element newChild;
  if (child != null) {
    bool hasSameSuperclass = true;
    if (hasSameSuperclass && child.widget == newWidget) {
      if (child.slot != newSlot) updateSlotForChild(child, newSlot);
      newChild = child;
    } else if (hasSameSuperclass &&
          Widget.canUpdate(child.widget, newWidget)) {
      if (child.slot != newSlot) updateSlotForChild(child, newSlot);
      child.update(newWidget);
      newChild = child;
    } else {
      deactivateChild(child);
      newChild = inflateWidget(newWidget, newSlot);
    }
  } else {
    newChild = inflateWidget(newWidget, newSlot);
  }
  return newChild;
}
```



## StatefulElement

```dart
class StatefulElement extends ComponentElement {
  @override
  void performRebuild() {
    if (_didChangeDependencies) {
      state.didChangeDependencies();
      _didChangeDependencies = false;
    }
    super.performRebuild();
  }
  
  @override
  Widget build() => state.build(this); // 用户在自定义State的子类里实现的构建方法
}
```



## ComponentElement

```dart
abstract class ComponentElement extends Element {
  @override
  @pragma('vm:notify-debugger-on-exception')
  void performRebuild() {
    if (!kReleaseMode && debugProfileBuildsEnabled)
      Timeline.startSync('${widget.runtimeType}',
          arguments: timelineArgumentsIndicatingLandmarkEvent);
    Widget? built;
    try {
      built = build();
      debugWidgetBuilderValue(widget, built);
    } catch (e, stack) {
      _debugDoingBuild = false;
      built = ErrorWidget.builder(
        _debugReportException(
          ErrorDescription('building $this'),
          e,
          stack,
          informationCollector: () sync* {
            yield DiagnosticsDebugCreator(DebugCreator(this));
          },
        ),
      );
    } finally {
      // We delay marking the element as clean until after calling build() so
      // that attempts to markNeedsBuild() during build() will be ignored.
      _dirty = false;
    }
    try {
      _child = updateChild(_child, built, slot);
    } catch (e, stack) {
      built = ErrorWidget.builder(
        _debugReportException(
          ErrorDescription('building $this'),
          e,
          stack,
          informationCollector: () sync* {
            yield DiagnosticsDebugCreator(DebugCreator(this));
          },
        ),
      );
      _child = updateChild(null, built, slot);
    }
    
 	 if (!kReleaseMode && debugProfileBuildsEnabled) Timeline.finishSync();
  }
  
  @protected
  Widget build();
}
```



# BuildOwner

```dart
final List<Element> _dirtyElements = <Element>[];

// 在【WidgetsBinding.drawFrame】调用【buildScope】时，添加一个element到dirty的element list，以便它会被重建。
void scheduleBuildFor(Element element) {
  if (element._inDirtyList) {
    _dirtyElementsNeedsResorting = true;
    return;
  }
  if (!_scheduledFlushDirtyElements && onBuildScheduled != null) {
    _scheduledFlushDirtyElements = true;
    onBuildScheduled!(); // 触发帧的调度
  }
  _dirtyElements.add(element); // 将当前State持有的Element对象加入脏表集合
  element._inDirtyList = true;
}

VoidCallback? onBuildScheduled;

// 建立一个范围更新widget树，并调用传入的callback。然后以dps构建[scheduleBuildFor]标记为dirty的所有elements
// 这个机制防止构建方法牵连到要求执行其他构建方法，以及由此可能带来的循环调用
@pragma('vm:notify-debugger-on-exception')
void buildScope(Element context, [VoidCallback? callback]) {
	if (callback == null && _dirtyElements.isEmpty) return;
  Timeline.startSync('Build',
        arguments: timelineArgumentsIndicatingLandmarkEvent);
  try {
    _scheduledFlushDirtyElements = true;
    if (callback != null) {
      Element? debugPreviousBuildTarget;
      _dirtyElementsNeedsResorting = false;
      try {
        callback();
      } finally {}
    }
    _dirtyElements.sort(Element._sort);
    _dirtyElementsNeedsResorting = false;
    int dirtyCount = _dirtyElements.length;
    int index = 0;
    while (index < dirtyCount) {
      try {
        _dirtyElements[index].rebuild();
      } catch (e, stack) {}
      index += 1;
      if (dirtyCount < _dirtyElements.length ||
            _dirtyElementsNeedsResorting!) {
        _dirtyElements.sort(Element._sort);
        _dirtyElementsNeedsResorting = false;
        dirtyCount = _dirtyElements.length;
        while (index > 0 && _dirtyElements[index - 1].dirty) {
          // It is possible for previously dirty but inactive widgets to move right in the list.
          // We therefore have to move the index left in the list to account for this.
          // We don't know how many could have moved. However, we do know that the only possible
          // change to the list is that nodes that were previously to the left of the index have
          // now moved to be to the right of the right-most cleaned node, and we do know that
          // all the clean nodes were to the left of the index. So we move the index left
          // until just after the right-most clean node.
          index -= 1;
        }
      }
    }
	} finally {
		for (final Element element in _dirtyElements) {
      element._inDirtyList = false;
    }
    _dirtyElements.clear();
    _scheduledFlushDirtyElements = false;
    _dirtyElementsNeedsResorting = null;
    Timeline.finishSync();
  }
}
```



# WidgetsBinding

```dart
mixin WidgetsBinding on BindingBase, ServicesBinding, SchedulerBinding, GestureBinding, RendererBinding, SemanticsBinding {
	void _handleBuildScheduled() {
    ensureVisualUpdate();
  }  
}
```

# SchedulerBinding

```dart
mixin SchedulerBinding on BindingBase {
  // 如果该对象现在没有在创建帧，则调用【scheduleFrame】申请一个新帧
  // 调用这个方法保证【handleDrawFrame】最终被调用，除非它已经被调用
  // 
  void ensureVisualUpdate() {
    switch (schedulerPhase) {
      case SchedulerPhase.idle:
      case SchedulerPhase.postFrameCallbacks:
        scheduleFrame();
        return;
      case SchedulerPhase.transientCallbacks:
      case SchedulerPhase.midFrameMicrotasks:
      case SchedulerPhase.persistentCallbacks:
        return;
    }
  }  
  
  // 如果有必要的话，调用[dart:ui.PlatformDispatcher.scheduleFrame]安排一个新的帧
  // 在该方法被调用后，引擎最终将调用[handleBeginFrame]。（这个调用可能delay，如果设备熄屏后，会delay到屏幕亮起，app可见）。
  // 在一个帧内调用该方法会强行启动另一个帧，即便当前帧还没完成
  // 使用OS提供的"Vsync"信号触发之后会使用调度的帧。
  // "Vsync"信息，或者垂直对齐信号，在硬件物理性地在显示更新间竖直移动一束电子时，被关联到显示刷新。
  // 当前的硬件的操作更加微妙和复杂，但是概念上的"Vsync"刷新信号继续被用于说明应用应该更新渲染的时机。
  void scheduleFrame() {
    if (_hasScheduledFrame || !framesEnabled)
      return;
    ensureFrameCallbacksRegistered();
    window.scheduleFrame();
    _hasScheduledFrame = true;
  }
}
```

# SchedulerPhase

```dart
// 在【SchedulerBinding.handleBeginFrame】期间，一个【SchedulerBinding】经历的各个阶段
enum SchedulerPhase {
  // 没有帧被处理.
  // Tasks ([SchedulerBinding.scheduleTask]安排的)
  // microtasks ([scheduleMicrotask]安排的)
  // [Timer] callback
  // event handler (比如用户输入)
  // 其他 callbacks (比如 [Future]s, [Stream]s)
  // 可能正在执行
	idle,
  // 短暂的callbacks ([SchedulerBinding.scheduleFrameCallback]安排的) 正在执行
  // 通常，这些callbacks负责更新对象到新的动画状态
  transientCallbacks,
  // 安排在处理短callbacks的期间的microtasks正在执行
  // 这包括，在[transientCallbacks]帧处理的futures的callbacks。
  midFrameMicrotasks,
  // 长callbacks（[SchedulerBinding.addPersistentFrameCallback]安排的）正在执行
  // 通常，这是一个构建/布局/绘制管线。
  persistentCallbacks,
  // post-frame callbacks（[SchedulerBinding.addPostFrameCallback]安排的）正在执行
  // 通常，这些callbacks为下一帧执行清理和工作计划
  postFrameCallbacks,
}
```



# SingletonFlutterWindow

```dart
class SingletonFlutterWindow extends FlutterWindow {
  // 在下一个合适的机会，请求调用[onBeginFrame]和[onDrawFrame]回调方法。
  // 调用这个方法会传递调用到[PlatformDispatcher]单例的同名方法，所以不要在这里调用，建议调用[WidgetsBinding.instance.platformDispatcher]。
  // 之所以要做这样的设计，是为了给只使用一个主窗口的应用提供便利。
  void scheduleFrame() => platformDispatcher.scheduleFrame();
}
```

