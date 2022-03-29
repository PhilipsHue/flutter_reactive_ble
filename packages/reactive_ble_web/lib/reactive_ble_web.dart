library reactive_ble_web;

export 'src/unsupported_library.dart'
    if (dart.library.html) 'src/reactive_ble_web_platform.dart';