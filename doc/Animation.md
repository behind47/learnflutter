```dart
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';

import 'tween.dart';

// Examples can assume:
// late AnimationController _controller;

/// The status of an animation.
enum AnimationStatus {
  /// The animation is stopped at the beginning.
  dismissed,

  /// The animation is running from beginning to end.
  forward,

  /// The animation is running backwards, from end to beginning.
  reverse,

  /// The animation is stopped at the end.
  completed,
}

/// Signature for listeners attached using [Animation.addStatusListener].
typedef AnimationStatusListener = void Function(AnimationStatus status);

/// An animation with a value of type `T`.
///
/// An animation consists of a value (of type `T`) together with a status. The
/// status indicates whether the animation is conceptually running from
/// beginning to end or from the end back to the beginning, although the actual
/// value of the animation might not change monotonically (e.g., if the
/// animation uses a curve that bounces).
///
/// Animations also let other objects listen for changes to either their value
/// or their status. These callbacks are called during the "animation" phase of
/// the pipeline, just prior to rebuilding widgets. 
/// animation帧发生在widgets重建之前
///
/// To create a new animation that you can run forward and backward, consider
/// using [AnimationController].
///
/// See also:
///
///  * [Tween], which can be used to create [Animation] subclasses that
///    convert `Animation<double>`s into other kinds of `Animation`s.
abstract class Animation<T> extends Listenable implements ValueListenable<T> {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const Animation();

  // keep these next five dartdocs in sync with the dartdocs in AnimationWithParentMixin<T>

  /// Calls the listener every time the value of the animation changes.
  ///
  /// Listeners can be removed with [removeListener].
  @override
  void addListener(VoidCallback listener);

  /// Stop calling the listener every time the value of the animation changes.
  ///
  /// If `listener` is not currently registered as a listener, this method does
  /// nothing.
  ///
  /// Listeners can be added with [addListener].
  @override
  void removeListener(VoidCallback listener);

  /// Calls listener every time the status of the animation changes.
  ///
  /// Listeners can be removed with [removeStatusListener].
  void addStatusListener(AnimationStatusListener listener);

  /// Stops calling the listener every time the status of the animation changes.
  ///
  /// If `listener` is not currently registered as a status listener, this
  /// method does nothing.
  ///
  /// Listeners can be added with [addStatusListener].
  void removeStatusListener(AnimationStatusListener listener);

  /// The current status of this animation.
  AnimationStatus get status;

  /// The current value of the animation.
  @override
  T get value;

  /// Whether this animation is stopped at the beginning.
  bool get isDismissed => status == AnimationStatus.dismissed;

  /// Whether this animation is stopped at the end.
  bool get isCompleted => status == AnimationStatus.completed;

  /// Chains a [Tween] (or [CurveTween]) to this [Animation].
  ///
  /// This method is only valid for `Animation<double>` instances (i.e. when `T`
  /// is `double`). This means, for instance, that it can be called on
  /// [AnimationController] objects, as well as [CurvedAnimation]s,
  /// [ProxyAnimation]s, [ReverseAnimation]s, [TrainHoppingAnimation]s, etc.
  /// AnimationController, CurvedAnimation, ProxyAnimation, reverseAnimation, TrainHoopingAnimation等可以调用这个方法，因为：他们都是Animation<double>的子类。
  ///
  /// It returns an [Animation] specialized to the same type, `U`, as the
  /// argument to the method (`child`), whose value is derived by applying the
  /// given [Tween] to the value of this [Animation].
  /// 返回的Animation的类型与传入的Tween相同
  ///
  /// {@tool snippet}
  ///
  /// Given an [AnimationController] `_controller`, the following code creates
  /// an `Animation<Alignment>` that swings from top left to top right as the
  /// controller goes from 0.0 to 1.0:
  /// AlignmentTween继承自Tween<Alignment> ，因此下面的_alignment1是Animation<Alignment>类型
  ///
Animation<Alignment> _alignment1 = _controller.drive(
   AlignmentTween(
     begin: Alignment.topLeft,
     end: Alignment.topRight,
   ),
);
  /// {@end-tool}
  /// {@tool snippet}
  ///
final Animatable<Alignment> _tween = AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight)
  .chain(CurveTween(curve: Curves.easeIn));
final Animation<Alignment> _alignment2 = _controller.drive(_tween);
  /// {@end-tool}
  /// {@tool snippet}
  ///
  /// The following code is exactly equivalent, and is typically clearer when
  /// the tweens are created inline, as might be preferred when the tweens have
  /// values that depend on other variables:
  ///
Animation<Alignment> _alignment3 = _controller
   .drive(CurveTween(curve: Curves.easeIn))
   .drive(AlignmentTween(
     begin: Alignment.topLeft,
     end: Alignment.topRight,
   )
);
  /// {@end-tool}
  ///
  @optionalTypeArgs
  Animation<U> drive<U>(Animatable<U> child) {
    assert(this is Animation<double>);
    return child.animate(this as Animation<double>);
  }
}

```



Animation保存一个动画的状态（status）和进度（value），并且可以添加和删除对状态与进度的监听——`addStatusListener(VoidCallback callback)`,`addListener(VoidCallback callback)`

以及`Animtation<U> drive(Animatable<U> tween)`方法

