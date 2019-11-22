import 'package:flutter_reactive_ble/src/model/generic_failure.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';

enum ConnectionPriority { balanced, highPerformance, lowPower }

int convertPriorityToInt(ConnectionPriority priority) {
  switch (priority) {
    case ConnectionPriority.balanced:
      return 0;
    case ConnectionPriority.highPerformance:
      return 1;
    case ConnectionPriority.lowPower:
      return 2;
    default:
      assert(false);
      return -1000;
  }
}

class ConnectionPriorityInfo {
  const ConnectionPriorityInfo({this.result});

  final Result<void, GenericFailure<ConnectionPriorityFailure>> result;
}

enum ConnectionPriorityFailure { unknown }
