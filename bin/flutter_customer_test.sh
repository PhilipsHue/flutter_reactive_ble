set -e

(cd packages/flutter_reactive_ble; flutter analyze --no-fatal-infos; flutter test)
(cd packages/reactive_ble_mobile; flutter analyze --no-fatal-infos; flutter test)
(cd packages/reactive_ble_platform_interface; flutter analyze --no-fatal-infos; flutter test)
