#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ReactiveBlePlugin.h"

FOUNDATION_EXPORT double reactive_ble_macosVersionNumber;
FOUNDATION_EXPORT const unsigned char reactive_ble_macosVersionString[];

