import 'dart:async';

import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

/// A disposable resource whose underlying resource can be replaced by another resource
/// causing automatic disposal of the previous underlying resource.
class SerialDisposable<T> {
  SerialDisposable(this._dispose);

  Future<void> set(T newValue) async {
    if (_isDisposed) {
      throw _SerialAlreadyDisposed(runtimeType);
    }
    if (_value != null) await _dispose(_value!);
    _value = newValue;
  }

  /// Dispose underlying resource
  Future<void> dispose() async {
    _isDisposed = true;
    if (_value != null) {
      await _dispose(_value!);
    }
  }

  /// Returns whether or not the underlying resource is disposed
  bool get isDisposed => _isDisposed;

  final Future<Unit> Function(T) _dispose;
  bool _isDisposed = false;
  T? _value;
}

class _SerialAlreadyDisposed extends Error {
  final Type _type;

  _SerialAlreadyDisposed(this._type);

  @override
  String toString() => "An instance of $_type has already been disposed";
}

/// A [SerialDisposable] that constains an underlying stream subscription.
class StreamSubscriptionSerialDisposable
    extends SerialDisposable<StreamSubscription> {
  StreamSubscriptionSerialDisposable()
      : super((StreamSubscription subscription) async {
          await subscription.cancel();
          return const Unit();
        });
}
