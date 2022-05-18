# RepaintBoundary

一个widget， 为其child创建一个独立的显示layer。 

1. 如果subtree重绘的时机与outer不同步，使用它可以提升性能。
2. **即便与其相关的widget 没有修改 或着 rebuild，也可以触发RenderObject.paint。**通常，多个RenderObject共享一个layer，当其中有部分RenderObject被标记为dirty（`RenderObject.markNeedsPaint`），需要重绘时，layer上的所有RenderObject都会重绘，e.g，当一个ancestor滚动或者当一个ancestor/descendant animats时。
3. ？？？？不能理解  对于使用`RepaintBoundary`的`render subtree`直接或间接地修改UI，为它们中的一部分包含有`RenderObject.paint`可以最小化冗余的工作，并提升app的性能。
4. 当一个`RenderObject`被标记为dirty时，*最近的带有`RenderObject.isRepaintBoundary`的`ancestor RenderObject`*，直到root，需要重绘。而，*最近的ancestor*的`RenderObject.paint`方法会导致它的所有descendant RenderObject在同一个layer上重绘。
5. RepaintBoundary通过`PaintingContext.paintChild`向下遍历render tree，找到UI变化的widget，并将其标记为`markNeedsPaint`。RepaintBoundary可以创建一个带有一个Layer的RenderObject，从而将ancestor render obejcts与descendant render objects解耦。
6. RepaintBoundary可能对engine有很多副作用，如果一个RepaintBoundary包含的render subtree很复杂，而且是静态的，同时将其包围的tree频繁的变化，那么RepaintBoundary就能充分提升效率。在这种情况下，engine可能会耗费一点时间来将subtree的像素值光栅化并缓存起来，从而提升未来的GPU重绘速度。
7. 几个framework widgets插入RepaintBoundary widgets来标记应用的自然分离点。e.g. Material Design drawers的内容一般不会在drawer 开启 - drawer关闭 的期间变化，所以当在过渡期间使用Drawer widget时，重绘被自动地包含到drawer的内部或外部。



小结：

被标记为dirty的widget需要重绘，dirty的条件比较丰富，包含且不限于大小变化，位置变化。因此，会存在冗余的重绘，比如滑动视图时，如果内容没有改变，并不需要重绘。使用RepaintBoundary，可以将subtree与outer分离，当outer重绘时，subtree不受影响。