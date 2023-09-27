import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

class ReactiveBleWebPlatform extends ReactiveBlePlatform {

  ReactiveBleWebPlatform();
}

class ReactiveBleWebPlatformFactory {
  const ReactiveBleWebPlatformFactory();
  ReactiveBleWebPlatform create() => ReactiveBleWebPlatform();
}
