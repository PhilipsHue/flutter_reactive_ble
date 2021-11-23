#import "ReactiveBlePlugin.h"

#if __has_include(<reactive_ble_mobile/reactive_ble_mobile-Swift.h>)
#import <reactive_ble_mobile/reactive_ble_mobile-Swift.h>
#else
#import "reactive_ble_mobile-Swift.h"
#endif

@implementation ReactiveBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftReactiveBlePlugin registerWithRegistrar:registrar];
}
@end
