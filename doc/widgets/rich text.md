富文本的使用

包含在text里添加图片

在button上添加富文本



```dart
const Text.rich(
	InlineSpan this.textSpan, {
    Key? key,
    this.style, // TextStyle
    this.textAlign,
    this.textDirection, // TextDirection
    this.locale,
    this.softWrap, // 是否换行，不然会渲染到屏幕外，并且不报错
    this.overflow,
    this.textScaleFactor, // 字体放大倍数
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis, // TextWidthBasis，测量一行或多行文本的方法，分为使用最长一行的宽度，和使用parent的宽度 
    this.textHeightBegavior,
  }
)
  
enum TextWidthBasis {
  parent,
  longestLine,
}  
```



官方的文本结构图

![官方的文本结构图](https://flutter.github.io/assets-for-api-docs/assets/painting/text_height_diagram.png)

