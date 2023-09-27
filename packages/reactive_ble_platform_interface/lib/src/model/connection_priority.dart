import '../model/unit.dart';
import 'generic_failure.dart';
import 'result.dart';

/// The priority that can be requested to update the connection parameter.
enum ConnectionPriority {
  /// connection with recommended parameters.
  balanced,

  /// high priority, low latency connection.
  highPerformance,
  // reduced power, low data rate connennection.
  lowPower,
}

///util function to convert priority to a integer.
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

/// Result of the connection priority request
class ConnectionPriorityInfo {
  const ConnectionPriorityInfo({required this.result});

  final Result<Unit, GenericFailure<ConnectionPriorityFailure>?> result;
}

/// Error type for connection priority.
enum ConnectionPriorityFailure { unknown }
