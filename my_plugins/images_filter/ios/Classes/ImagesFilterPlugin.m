#import "ImagesFilterPlugin.h"
#if __has_include(<images_filter/images_filter-Swift.h>)
#import <images_filter/images_filter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "images_filter-Swift.h"
#endif

@implementation ImagesFilterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImagesFilterPlugin registerWithRegistrar:registrar];
}
@end
