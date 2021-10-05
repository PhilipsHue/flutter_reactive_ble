#import "ReactiveBlePlugin.h"
#import <reactive_ble_macos/reactive_ble_macos-Swift.h>

@implementation ReactiveBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftReactiveBlePlugin registerWithRegistrar:registrar];
}
@end
