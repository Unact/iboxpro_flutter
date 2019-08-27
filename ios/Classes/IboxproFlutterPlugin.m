#import "IboxproFlutterPlugin.h"
#import <iboxpro_flutter/iboxpro_flutter-Swift.h>

@implementation IboxproFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIboxproFlutterPlugin registerWithRegistrar:registrar];
}
@end
