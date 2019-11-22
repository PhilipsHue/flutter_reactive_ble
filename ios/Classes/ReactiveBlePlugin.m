#import "ReactiveBlePlugin.h"
#import <flutter_reactive_ble/flutter_reactive_ble-Swift.h>

@implementation ReactiveBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftReactiveBlePlugin registerWithRegistrar:registrar];
}
@end
