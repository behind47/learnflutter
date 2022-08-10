/// ## Lifecycle of resolving an image
///
/// The [ImageProvider] goes through the following lifecycle to resolve an
/// image, once the [resolve] method is called:
///
///   1. Create an [ImageStream] using [createStream] to return to the caller.
///      This stream will be used to communicate back to the caller when the
///      image is decoded and ready to display, or when an error occurs.
///   2. Obtain the key for the image using [obtainKey].
///      Calling this method can throw exceptions into the zone asynchronously
///      or into the callstack synchronously. To handle that, an error handler
///      is created that catches both synchronous and asynchronous errors, to
///      make sure errors can be routed to the correct consumers.
///      The error handler is passed on to [resolveStreamForKey] and the
///      [ImageCache].
///   3. If the key is successfully obtained, schedule resolution of the image
///      using that key. This is handled by [resolveStreamForKey]. That method
///      may fizzle if it determines the image is no longer necessary, use the
///      provided [ImageErrorListener] to report an error, set the completer
///      from the cache if possible, or call [load] to fetch the encoded image
///      bytes and schedule decoding.
///   4. The [load] method is responsible for both fetching the encoded bytes
///      and decoding them using the provided [DecoderCallback]. It is called
///      in a context that uses the [ImageErrorListener] to report errors back.
///
/// Subclasses normally only have to implement the [load] and [obtainKey]
/// methods. A subclass that needs finer grained control over the [ImageStream]
/// type must override [createStream]. A subclass that needs finer grained
/// control over the resolution, such as delaying calling [load], must override
/// [resolveStreamForKey].
///
/// The [resolve] method is marked as [nonVirtual] so that [ImageProvider]s can
/// be properly composed, and so that the base class can properly set up error
/// handling for subsequent methods.
///

[resolve]方法解析图像的流程：
1. 调用者使用[createStream]创建一个[ImageStream]。当图像完成解码后等待显示时，或者发生error时，都可以使用[ImageStream]通知到调用者。
2. 使用[obtainKey]获取一个key来标记图像。调用这个方法时，可能异步抛出异常给zone，或者同步抛出异常给调用栈。对于这些异常，可以创建一个error handler来捕获，确保erros能被交付给合适的consumers。这个error handler被传递给[resolveStreamForKey]和[ImageCache]。
3. 如果成功获取到key，则使用它来触发image的解析。解析逻辑在[resolveStreamForKey]中，如果它觉得图像不再需要，会返回失败的结果，使用2里提供的[ImageErrorListener]来抛出一个错误，设置来自缓存的completer，或者调用[load]来获取编码的图像数据，并调度解码流程。
4. [load]方法负责接收编码的图像数据，并使用提供的[DecoderCallback]将其解码。调用它的上下文会使用[ImageErrorListener]抛出错误。

子类通常只需要实现[load]和[obtainKey]方法。如果一个子类需要对[ImageStream]有更细粒度的控制，必须重写[createStream]。如果一个子类需要对解析有更细粒度的控制，比如延迟调用[load]，必修重写[resolveStreamForKey].

[resolve]被标记为[nonVirtual]，所以[ImageProvider]们能被组合，基类能为随后的方法设置error handler。