#import "ReactiveBlePlugin.h"
#import <reactive_ble_mobile/reactive_ble_mobile-Swift.h>

@implementation ReactiveBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftReactiveBlePlugin registerWithRegistrar:registrar];
}
@end
