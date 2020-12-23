import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_reactive_ble/src/debug_logger.dart' as _i2;
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart'
    as _i3;
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart'
    as _i4;
import 'package:flutter/src/services/platform_channel.dart' as _i5;

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i2.Logger {
  MockLogger() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [ArgsToProtobufConverter].
///
/// See the documentation for Mockito's code generation for more information.
class MockArgsToProtobufConverter extends _i1.Mock
    implements _i3.ArgsToProtobufConverter {
  MockArgsToProtobufConverter() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [ProtobufConverter].
///
/// See the documentation for Mockito's code generation for more information.
class MockProtobufConverter extends _i1.Mock implements _i4.ProtobufConverter {
  MockProtobufConverter() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [MethodChannel].
///
/// See the documentation for Mockito's code generation for more information.
class MockMethodChannel extends _i1.Mock implements _i5.MethodChannel {
  MockMethodChannel() {
    _i1.throwOnMissingStub(this);
  }
}
