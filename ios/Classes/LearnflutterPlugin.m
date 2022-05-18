#import "LearnflutterPlugin.h"
#if __has_include(<learnflutter/learnflutter-Swift.h>)
#import <learnflutter/learnflutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "learnflutter-Swift.h"
#endif

@implementation LearnflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLearnflutterPlugin registerWithRegistrar:registrar];
}
@end
