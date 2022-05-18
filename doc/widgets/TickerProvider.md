SchedulerBinding会驱动ticker，在每一帧调用ticker的callback。

Ticker的构造方法只在TickerProvider的工厂方法createTicker中被调用，因此所有的ticker都是通过tickerProvider生产的。

Overscroll_indicator与AnimationController都会用到tickerProvider。

AnimationController的构造需要传入TickerProvider，其生成的ticker注册了AnimationController的_listeners列表作为callbacks，因此每一帧都会调用_listeners里的监听方法。





## TickerMode

启用或取消子树的`tickers`以及关联的`animation controllers`

只有当`AnimationController`对象是使用`widget-aware ticker providers`创建的时候才生效。

举例，使用一个`TickerProviderStateMixin`或一个`SingleTickerProviderStateMixin`

```dart
class TickerMode extends StatelessWidget {
  const TickerMode({
    Key? key,
    // 子树的ticker mode，如果false，tickers驱动的动画仍然进行，但是不执行callbacks
    required this.enabled,
    required this.child,
  }) : assert(enabled != null),
       super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _EffectiveTickerMode(
      enabled: enabled && TickerMode.of(context),
      child: child,
    );
  }

}
```





## TickerProviderStateMixin

提供`Ticker`对象，只在当前tree启用的时候tick，如`TickerMode`定义。

在使用了该`mixin`的类中创建一个`AnimationController`，在构造方法中传入`vsync: this`属性。

只有一个`Ticker`的情况下使用`SingleTickerProviderStateMixin`更有效率。





## TickerProvider





## Ticker

```dart
class Ticker {
  Ticker(this._onTick, { this.debugLabel }) {
    assert(() {
      _debugCreationStack = StackTrace.current;
      return true;
    }());
  }
  // 每一帧都会调用一次这个callback
  final TickerCallback _onTick;
}

typedef TickerCallback = void Function(Duration elapsed);
```

