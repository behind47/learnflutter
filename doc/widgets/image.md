# Image

显示图像的widget。

创建image的方法有5种：

1. `Image(ImageProvider provider)`，`ImageProvider`是抽象类，常用的子类有：`NetworkImage`用于展示网络图片。
2. `Image.asset(String assetBundleName)`
3. `Image.network(String srcURL)`
4. `Image.file(File file)`
5. `Image.memory(Uint8List imageBits)`

支持宏 flutter.dart:ui.imageFormats 规定的图片格式

使用【AssetImage】设置图片，并将其放在一个【MaterialApp】，【WidgetApp】，或【MediaQuery】 widget下，可以自动处理像素密度感知。

image是使用【paintImage】方法绘制的。

减少缓存内存——使用构造器的`cacheWidth`和`cacheHeight`参数，engine会将图片解码到指定的尺寸，从而减少使用【ImageCache】时的内存占用。

如果是在web浏览器上使用网络图片，由于图片的解压是web浏览器负责的，因此设置构造器的`cacheWidth`和`cacheHeight`参数不会起作用。

```dart
class Image extends StatefulWidget {
  const Image({
    Key? key,
    required this.image,
    this.aligment = Aligment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false, // 与文本方向一致
    this.frameBuilder, // 可以用来构建图像动效或placeholder
    this.loadingBuilder, // 构建一个loading widget，在图像加载时显示
    this.errorBuilder, // 加载失败的图片
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode, // 颜色与图像的混合模式
    this.fit,
    this.centerSlice, // 点9图可以伸缩的区域
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low, // 缩放时采用的插值算法的质量
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })
    
  @override
  State<Image> createState() => _ImageState();
}

class _ImageState extends State<Image> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    if (_lastException != null) {
      if (widget.errorBuilder != null)
        // 显示异常widget
        return widget.errorBuilder!(context, _lastException!, _lastStack);
      if (kDebugMode)
        return _debugBuildErrorWidget(context, _lastException!);
    }

    Widget result = RawImage(
      // Do not clone the image, because RawImage is a stateless wrapper.
      // The image will be disposed by this state object when it is not needed
      // anymore, such as when it is unmounted or when the image stream pushes
      // a new image.
      image: _imageInfo?.image,
      debugImageLabel: _imageInfo?.debugLabel,
      width: widget.width,
      height: widget.height,
      scale: _imageInfo?.scale ?? 1.0,
      color: widget.color,
      opacity: widget.opacity,
      colorBlendMode: widget.colorBlendMode,
      fit: widget.fit,
      alignment: widget.alignment,
      repeat: widget.repeat,
      centerSlice: widget.centerSlice,
      matchTextDirection: widget.matchTextDirection,
      invertColors: _invertColors,
      isAntiAlias: widget.isAntiAlias,
      filterQuality: widget.filterQuality,
    );

    if (!widget.excludeFromSemantics) {
      result = Semantics(
        container: wid
        get.semanticLabel != null,
        image: true,
        label: widget.semanticLabel ?? '',
        child: result,
      );
    }

    if (widget.frameBuilder != null)
      result = widget.frameBuilder!(context, result, _frameNumber, _wasSynchronouslyLoaded);

    if (widget.loadingBuilder != null)
      result = widget.loadingBuilder!(context, result, _loadingProgress);

    return result;
  }
}
```



可以看到，frameBuilder与loadingBuilder可以嵌套。

两个builder都设置时，嵌套关系是

loadingBuilder -> frameBuilder -> Image

举个例子

```dart
Image(
	...
  frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) => Padding(padding: EdgetInsets.all(8.0), child: child),
  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) => Center(child: child),
)
```

由于两者的绑定，widget层级会包含

```dart
Center(
	Padding(
    padding: EdgetInsets.all(8.0),
    child: <Image>
  )
)
```



## ImageFrameBuilder

```dart
typedef ImageFrameBuilder = Widget Function(
	BuildContext context,
  Widget child, // 包含图像widget，非空
  int? frame, // 图像帧的序号，从0开始，对于静态图为0，对于动图为当前展示帧的序号，动图循环时该值不重置，继续增长
  bool wasSynchronouslyLoaded, // 图像是否可以同步获取并立刻显示
);
```



## ImageLoadingBuilder

```dart
typedef ImageLoadingBuilder = Widget Function(
  BuildContext context,
  Widget child, // 包含图像widget，非空
  ImageChunkEvent? loadingProgress, // 图片加载进度，图片加载开始前和图片加载完成后该值为空
);

class ImageChunkEvent with Diagnosticable {
  const ImageChunkEvent({
    required this.cumulativeBytesLoaded, // 已经接收到的bytes
    required this.expectedTotalBytes, // 待接收的bytes，不知道则为null
  }) : assert(cumulativeBytesLoaded >= 0),
  		 assert(expectedTotalBytes == null || expectedTotalBytes >= 0);
}
```



## ImageErrorWidgetBuilder

```dart
typedef ImageErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);
```





# ImageStreamListener

一个接口，用于在加载图片时获取通知。

```dart
class ImageStreamListener {
  const ImageStreamListener(
    this.onImage, {
    this.onChunk,
    this.onError,
  }) : assert(onImage != null);
  
  // 图像加载完成触发。如果一个图像包含多个帧，比如gif，则这个通知会触发多次
  final ImageListener onImage;
  // 在加载图像时，每接收到一大块bytes，就通知一次
  final ImageChunkListener? onChunk;
  // 加载图像失败时出发
  final ImageErrorListener? onError;
}

typedef ImageListener = void Function(ImageInfo image, bool synchronousCall);
```



