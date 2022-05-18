## AnimationBehavior

描述`animations`禁用时`AnimationController`的行为

```dart
enum AnimationBehavior {
  normal,
  preserve // 保留动画行为
}
```



## AnimationController

```dart
class AnimationController extends Animation<double>
  with AnimationEagerListenerMixin, AnimationLocalListenersMixin, AnimationLocalStatusListenersMxin {
  
}
```